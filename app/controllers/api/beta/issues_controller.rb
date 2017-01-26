# frozen_string_literal: true
module Api
  module Beta
    class IssuesController < ApplicationController
      def index
        @issues_report     = Issue.aggregate_issues
        @unresolved_issues = Issue.unresolved

        render json: { issues_report: @issues_report, unresolved_issues: @unresolved_issues }
      end

      def new
        @issue_categories = ['Incorrect phone number',
                             'Office location moved',
                             'V-card won\'t download or is inaccurate',
                             'Incorrect Email',
                             'Incorrect social media handle',
                             'Incorrect website URL']
        @issue = Issue.new

        render json: { issue_categories: @issue_categories, issue: @issue }
      end

      def create
        issue_type = issue_params[:issue_type]

        if issue_type.is_a?(Array)
          @response = []
          issue_type.each do |issue|
            @issue = Issue.new(issue_type: issue, office_location_id: issue_params[:office_location_id])
            @response << @issue.save ? { status: :created } : { status: :unprocessable_entity }
          end

        else
          @issue = Issue.new(issue_params)
          @response = @issue.save ? { status: :created } : { status: :unprocessable_entity }
        end

        render json: @response
      end

      def update
        issue = Issue.find_by(id: params[:id])
        if issue.update_attributes(resolved: true)
          render json: { status: :reset_content }
        else
          render json: { status: :unprocessable_entity }
        end
      end

      private

      def issue_params
        params.require(:issue).permit(:issue_type, :resolved, :office_location_id, issue_type: [])
      end
    end
  end
end
