require_dependency 'application_helper'

module PlayApplicationHelperPatch

    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            alias_method :link_to_issue_with_subject, :link_to_issue
            alias_method :link_to_issue, :link_to_issue_without_subject
        end
    end

    module InstanceMethods

        def link_to_issue_without_subject(issue, options = {})
            link_to_issue_with_subject(issue, options.merge(:subject => false))
        end

    end

end
