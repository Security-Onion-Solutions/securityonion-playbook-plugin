require_dependency 'welcome_controller'

module PlayWelcomeControllerPatch

    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            before_action :redirect_to_main_project, :only => :index
        end
    end

    module InstanceMethods

    private

        def redirect_to_main_project
            if Setting.plugin_redmine_playbook['project'].present? && (project = Project.find_by_id(Setting.plugin_redmine_playbook['project']))
                redirect_to_project_menu_item(project, :issues)
            end
        end

    end

end
