{
  meta = {
    traceId = "FS-165-HDS-010-SDS-010-SMS-010";
    scope = "source-value-necessity-validation";
    evidenceClass = "construction-only";
  };
  module_checks = [
    {
      sms_id = "FS-165-HDS-010-SDS-010-SMS-010";
      consumed_interfaces = [
        "source_manifest" "source_class_ledger" "requested_scope"
        "requested_target_or_role" "downstream_derivation_declarations"
      ];
      emitted_interfaces = [
        "source_value_necessity_decision" "source_value_rejection_diagnostic"
        "downstream_home_recommendation"
      ];
      failure_conditions = [
        "source_value_has_no_allowed_class_or_downstream_derivation_reason"
        "source_value_duplicates_downstream_detail"
        "source_value_creates_unmodeled_behavior_or_realization"
      ];
      downstream_invention = false;
      script_local_policy = false;
      renderer_inference = false;
      broad_parent_coverage = false;
    }
    {
      sms_id = "FS-165-HDS-010-SDS-010-SMS-020";
      consumed_interfaces = [
        "source_manifest" "parsed_source_form_records" "source_class_ledger"
        "declared_roles_scopes_relationships" "fixture_context"
        "renderer_target" "downstream_derivation_rules"
      ];
      emitted_interfaces = [
        "normalized_source_form_review_record"
        "minimality_readability_diagnostic"
        "source_shape_warning_or_failure_classification"
      ];
      failure_conditions = [
        "duplicated_classification_fields" "parallel_names_for_same_concept"
        "target_specific_labels" "fixture_hints" "renderer_hints"
        "copied_platform_metadata" "downstream_derivable_source_fields"
      ];
      downstream_invention = false;
      script_local_policy = false;
      renderer_inference = false;
      broad_parent_coverage = false;
    }
    {
      sms_id = "FS-165-HDS-010-SDS-010-SMS-030";
      consumed_interfaces = [
        "source_form_review_findings" "required_distinction_rules"
        "requested_scope" "requested_target_or_role"
        "downstream_consumer_identity"
      ];
      emitted_interfaces = [
        "downstream_contract_gap_diagnostic" "blocked_consumption_decision"
        "suggested_downstream_contract_target"
      ];
      failure_conditions = [
        "required_distinction_has_no_normalized_representation"
        "consumer_would_infer_from_ad_hoc_padding"
        "missing_downstream_contract_promotes_non_source_truth"
      ];
      downstream_invention = false;
      script_local_policy = false;
      renderer_inference = false;
      broad_parent_coverage = false;
    }
  ];
  source_value_cases = [
    {
      case_kind = "valid";
      value_name = "tenant.access.internet_mode";
      source_class = "intent";
      affected_scope = "tenant=access";
      required_for_source_truth = true;
      downstream_derivation_reason = "";
      non_source_truth_detail = false;
      creates_unmodeled_behavior = false;
      binds_unmodeled_realization = false;
      emitted_interface = "source_value_necessity_decision";
    }
    {
      case_kind = "failure";
      value_name = "rendered_nft_chain_name";
      source_class = "user_intent";
      affected_scope = "site=controlled-network";
      required_for_source_truth = true;
      downstream_derivation_reason = "";
      non_source_truth_detail = true;
      creates_unmodeled_behavior = false;
      binds_unmodeled_realization = false;
      downstream_home = "renderer output";
      emitted_interface = "source_value_rejection_diagnostic";
      failure_reason = "source_value_duplicates_downstream_detail";
    }
    {
      case_kind = "failure";
      value_name = "unclassifiable_value";
      source_class = "unknown";
      affected_scope = "site=controlled-network";
      required_for_source_truth = false;
      downstream_derivation_reason = "";
      non_source_truth_detail = false;
      creates_unmodeled_behavior = false;
      binds_unmodeled_realization = false;
      downstream_home = "renderer fixture metadata";
      emitted_interface = "source_value_rejection_diagnostic";
      failure_reason = "source_value_has_no_allowed_class_or_downstream_derivation_reason";
    }
  ];
  readability_cases = [
    {
      case_kind = "valid";
      source_record = "site-role-relationship";
      normalized_record_fields = ["site" "role" "scope" "relationship"];
      left_to_right_readable = true;
      intent_inventory_boundaries_visible = true;
      emitted_interface = "normalized_source_form_review_record";
    }
    {
      case_kind = "failure";
      source_record = "duplicated-classification";
      normalized_record_fields = ["field" "source_class"];
      left_to_right_readable = false;
      intent_inventory_boundaries_visible = true;
      duplicated_classification_fields = true;
      emitted_interface = "minimality_readability_diagnostic";
      failure_reason = "duplicated_classification_fields";
    }
    {
      case_kind = "failure";
      source_record = "parallel-names";
      normalized_record_fields = ["role" "scope"];
      left_to_right_readable = false;
      intent_inventory_boundaries_visible = true;
      parallel_names_for_same_concept = true;
      emitted_interface = "minimality_readability_diagnostic";
      failure_reason = "parallel_names_for_same_concept";
    }
    {
      case_kind = "failure";
      source_record = "target-label";
      normalized_record_fields = ["role" "scope"];
      left_to_right_readable = false;
      intent_inventory_boundaries_visible = true;
      target_specific_labels = true;
      emitted_interface = "minimality_readability_diagnostic";
      failure_reason = "target_specific_labels";
    }
    {
      case_kind = "failure";
      source_record = "fixture-hint";
      normalized_record_fields = ["role" "scope"];
      left_to_right_readable = false;
      intent_inventory_boundaries_visible = true;
      fixture_hints = true;
      emitted_interface = "minimality_readability_diagnostic";
      failure_reason = "fixture_hints";
    }
    {
      case_kind = "failure";
      source_record = "renderer-hint";
      normalized_record_fields = ["role" "scope"];
      left_to_right_readable = false;
      intent_inventory_boundaries_visible = true;
      renderer_hints = true;
      emitted_interface = "minimality_readability_diagnostic";
      failure_reason = "renderer_hints";
    }
    {
      case_kind = "failure";
      source_record = "copied-platform-metadata";
      normalized_record_fields = ["role" "scope"];
      left_to_right_readable = false;
      intent_inventory_boundaries_visible = false;
      copied_platform_metadata = true;
      emitted_interface = "minimality_readability_diagnostic";
      failure_reason = "copied_platform_metadata";
    }
    {
      case_kind = "failure";
      source_record = "derivable-field";
      normalized_record_fields = ["role" "scope"];
      left_to_right_readable = false;
      intent_inventory_boundaries_visible = true;
      downstream_derivable_fields = true;
      emitted_interface = "minimality_readability_diagnostic";
      failure_reason = "downstream_derivable_source_fields";
    }
  ];
  downstream_gap_cases = [
    {
      case_kind = "represented";
      affected_source = "site-role-relationship";
      affected_scope = "site=controlled-network";
      role = "policy-point";
      missing_distinction = "none";
      downstream_contract_target = "normalized source-form record";
      normalized_representation_available = true;
      consumer_blocked = false;
      ad_hoc_source_field_allowed = false;
      emitted_interface = "blocked_consumption_decision";
    }
    {
      case_kind = "gap";
      affected_source = "source-form-review";
      affected_scope = "site=controlled-network";
      role = "provider-handoff";
      missing_distinction = "required handoff subtype cannot be expressed by normalized role/scope relationship";
      downstream_contract_target = "GAMP/SDS or GAMP/SMS source-form contract";
      normalized_representation_available = false;
      consumer_blocked = true;
      ad_hoc_source_field_allowed = false;
      emitted_interface = "downstream_contract_gap_diagnostic";
      failure_reason = "required_distinction_has_no_normalized_representation";
    }
  ];
}
