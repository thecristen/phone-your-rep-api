module Api
  module Beta
    class IssuesController < ApplicationController

      def index
        @issues_report = Issue.aggregate_issues
        @unresolved_issues = Issue.unresolved

        render json: { issues_report: @issues_report, unresolved_issues: @unresolved_issues }
      end

      def new
        @issue_categories = ['Incorrect phone number', 'Office location moved', 'Trouble downloading v-card', 'Incorrect Email']
        @issue = Issue.new

        render json: { issue_categories: @issue_categories, issue: @issue }
      end

      def create
        @issue = Issue.create(issue_params)
        if @issue.save
          @response = { status: :created }
        else
          @response = { status: :unprocessable_entity }
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
        params.require(:issue).permit(:issue_type, :resolved, :office_location_id)
      end
    end
  end
end
