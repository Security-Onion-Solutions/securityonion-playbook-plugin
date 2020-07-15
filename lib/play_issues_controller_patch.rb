require_dependency 'issues_controller'

module PlayIssuesControllerPatch

    def self.included(base)
        base.send(:prepend, InstanceMethods)
    end

    module InstanceMethods

        def redirect_back_or_default(default, options = {})
            default = project_issues_path(@issue.project) if action_name == 'create'
            if action_name == 'update' || (action_name == 'create' && Setting.plugin_redmine_playbook['import_trackers'].is_a?(Array) &&
                                                                      Setting.plugin_redmine_playbook['import_trackers'].include?(@issue.tracker_id.to_s))
                @url = params[:back_url] || default
                render :action => 'wait'
            else
                super(default, options)
            end
        end

    end

end
