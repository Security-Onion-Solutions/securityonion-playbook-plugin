require_dependency 'projects_controller'

module PlayProjectsControllerPatch

    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            before_action :enforce_issues_jump, :only => :show
        end
    end

    module InstanceMethods

    private

        def enforce_issues_jump
            params[:jump] ||= :issues
        end

    end

end
