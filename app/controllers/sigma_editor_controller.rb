require 'net/http'

class ConnectionFailed < Exception; end

class SigmaEditorController < ApplicationController
    menu_item :sigma_editor

    before_action :find_project, :authorize

    def edit
    end

    def example
        example = File.join(Redmine::Plugin.find(:redmine_playbook).directory, 'config/example.yaml')
        return render_404 unless File.exists?(example)
        params[:input] = File.read(example)
        respond_to do |format|
            format.html { render :action => 'edit' }
            format.js
        end
    end

    def example2
        example2 = File.join(Redmine::Plugin.find(:redmine_playbook).directory, 'config/example2.yaml')
        return render_404 unless File.exists?(example2)
        params[:input] = File.read(example2)
        respond_to do |format|
            format.html { render :action => 'edit' }
            format.js
        end
    end
    
    def example3
        example3 = File.join(Redmine::Plugin.find(:redmine_playbook).directory, 'config/example3.yaml')
        return render_404 unless File.exists?(example2)
        params[:input] = File.read(example2)
        respond_to do |format|
            format.html { render :action => 'edit' }
            format.js
        end
    end

    def convert
        return render_403 if Setting.plugin_redmine_playbook['convert_url'].blank?
        begin
            response = send_request(params[:input].to_s, Setting.plugin_redmine_playbook['convert_url'])
            if response.code.to_i == 200
                @output = response.body
            else
                Rails.logger.warn "Convert URL returned: #{response.code}."
                @error = l(:error_conversion_failed)
            end
        rescue ConnectionFailed
            Rails.logger.warn "Could not connect to convert URL."
            @error = l(:error_connection_failed)
        end
        respond_to do |format|
            format.html { render :action => 'edit' }
            format.js
        end
    end

    def create
        return render_403 if Setting.plugin_redmine_playbook['create_url'].blank?
        begin
            response = send_request(params[:input].to_s, Setting.plugin_redmine_playbook['create_url'])
            if response.code.to_i == 200
                data = ActiveSupport::JSON.decode(response.body) rescue nil
                if data.is_a?(Hash) && data['play_creation'] == 201
                    @redirect_url = data['play_url']
                else
                    @error = l(:error_creation_failed_with_status, :status => data['play_creation'])
                end
            else
                Rails.logger.warn "Create URL returned: #{response.code}."
                @error = l(:error_creation_failed)
            end
        rescue ConnectionFailed
            Rails.logger.warn "Could not connect to create URL."
            @error = l(:error_connection_failed)
        end
        respond_to do |format|
            format.html {
                if @error.present?
                    render :action => 'edit'
                else
                    redirect_to @redirect_url
                end
            }
            format.js
        end
    end

private

    def send_request(yaml, url)
        url = URI.parse(url) rescue nil
        headers = { 'Content-Type' => 'text/x-yaml' }
        begin
            Net::HTTP.post(url, yaml, headers)
        rescue SystemCallError, IOError, NoMethodError
            raise ConnectionFailed
        end
    end

end
