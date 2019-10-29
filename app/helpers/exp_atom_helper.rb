module ExpAtomHelper
  # Selection for count based filters
  EXP_COUNT_TYPE = [N_("Count of"), "count"].freeze

  # Selection for find/check filters
  EXP_FIND_TYPE = [N_("Find"), "find"].freeze

  # All normal filters
  EXP_TYPES = [
    [N_("Field"), "field"],
    EXP_COUNT_TYPE,
    [N_("Tag"), "tag"],
    EXP_FIND_TYPE
  ].freeze

  # Special VM registry filter
  VM_EXP_TYPES = [
    [N_("Registry"), "regkey"]
  ].freeze

  def self.expression_types_for(model, expkey, edit_expkey)
    expression_types = EXP_TYPES.map { |x| [_(x[0]), x[1]] }
    opts = []
    unless model == "_display_filter_"
      # Not valid for secondary display filter
      unless MiqExpression.miq_adv_search_lists(model, :exp_available_counts).length > 0
        expression_types -= [[_(EXP_COUNT_TYPE[0]), EXP_COUNT_TYPE[1]]]
      end

      unless MiqExpression.miq_adv_search_lists(model, :exp_available_finds).length > 0
        expression_types -= [[_(EXP_FIND_TYPE[0]), EXP_FIND_TYPE[1]]]
      end
    end

    case model
    when 'Vm'
      opts += expression_types + VM_EXP_TYPES.map { |x| [_(x[0]), x[1]] }
    when 'AuditEvent'
      opts += [[_('Field'), 'field']]
    when '_display_filter_'
      unless edit_expkey[:exp_available_fields].empty?
        opts.push([_('Field'), 'field'])
      end

      unless edit_expkey.tags_for_display_filters.empty?
        opts.push([_('Tag'), 'tag'])
      end
    when 'MiqGroup'
      if expkey == :filter_expression
        opts = [[_('Tag'), 'tags']]
        edit_expkey[:exp_typ] = 'tags'
      else
        opts += expression_types
      end
    else
      opts += expression_types
    end

    opts
  end
end
