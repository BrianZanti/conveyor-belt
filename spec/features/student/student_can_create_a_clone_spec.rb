require 'rails_helper'

feature 'User creates a new clone' do
  scenario 'with valid options' do
    student = create(:student)
    project = create(:project, hash_id: "abc123", user: student, project_board_base_url: "https://github.com/turingschool/newb-tube/projects/1")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(student)

    expect(ProjectBoardClonerWorker).to receive(:perform_later).with array_including(project, "bambi@example.com")

    visit new_project_clone_path(project_id: project.hash_id)

    fill_in :students, with: "Flower, Thumper, Bambi"
    fill_in :email, with: "bambi@example.com"

    expect {
      click_on "Submit"
    }.to change { Clone.count }.by(1)

    expect(current_path).to eq(root_path)
  end
end
