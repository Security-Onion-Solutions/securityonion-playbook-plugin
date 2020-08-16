require 'redmine'

require_dependency 'playbook_hooks'

Rails.logger.info 'Starting Playbook Plugin for Redmine'

Rails.configuration.to_prepare do
    unless WelcomeController.included_modules.include?(PlayWelcomeControllerPatch)
        WelcomeController.send(:include, PlayWelcomeControllerPatch)
    end
    unless AccountController.included_modules.include?(PlayAccountControllerPatch)
        AccountController.send(:include, PlayAccountControllerPatch)
    end
    unless ProjectsController.included_modules.include?(PlayProjectsControllerPatch)
        ProjectsController.send(:include, PlayProjectsControllerPatch)
    end
    unless IssuesController.included_modules.include?(PlayIssuesControllerPatch)
        IssuesController.send(:include, PlayIssuesControllerPatch)
    end
    unless ApplicationHelper.included_modules.include?(PlayApplicationHelperPatch)
        ApplicationHelper.send(:include, PlayApplicationHelperPatch)
    end
    unless Issue.included_modules.include?(PlayIssuePatch)
        Issue.send(:include, PlayIssuePatch)
    end
end

Redmine::Plugin.register :redmine_playbook do
    name 'Playbook'
    author 'Andriy Lesyuk'
    author_url 'http://www.andriylesyuk.com/'
    description 'Playbook customizations for Redmine'
    version '0.1.2'

    project_module :sigma_editor do
        permission :sigma_editor, { :sigma_editor => [ :edit, :example, :example2, :example3, :convert, :create ] }
    end

    Redmine::MenuManager.map :top_menu do |menu|
        menu.delete :my_page
        menu.delete :projects
        menu.delete :help
    end

    Redmine::MenuManager.map :project_menu do |menu|
        menu.delete :overview

        menu.push :sigma_editor, { :controller => 'sigma_editor', :action => 'edit' }, :before => :news,
                  :if => Proc.new { |project| Setting.plugin_redmine_playbook['convert_url'].present? }
    end

    settings :default => {
        'project'         => nil,
        'import_trackers' => [],
        'convert_url'     => nil,
        'create_url'      => nil
    }, :partial => 'settings/playbook'
end
