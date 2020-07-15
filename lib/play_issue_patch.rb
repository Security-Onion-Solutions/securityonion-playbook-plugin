require_dependency 'issue'

module PlayIssuePatch

    DEFAULT_SUBJECT = '(no subject)'

    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            before_validation :default_subject
        end
    end

    module InstanceMethods

    private

        def default_subject
            if subject.blank? && read_only_attribute_names.include?('subject')
                self.subject = DEFAULT_SUBJECT
            end
        end

    end

end
