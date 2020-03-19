require_dependency 'account_controller'

module PlayAccountControllerPatch

    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            before_action :enforce_main_project_redirection, :only => :login
        end
    end

    module InstanceMethods

    private

        def enforce_main_project_redirection
            if params[:back_url].blank? && Setting.plugin_redmine_playbook['project'].present? && (project = Project.find_by_id(Setting.plugin_redmine_playbook['project']))
                params[:back_url] = project_issues_url(project)
            end
        end

    end

end
