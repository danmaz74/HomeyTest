# seeds for testing purposes

project_owner = User.create email: 'project_owner@test.com', password: 'project_owner',
                            name: 'Project Owner'
other_user = User.create email: 'other_user@test.com', password: 'other_user', name: 'Other User'

Project.create owner: project_owner, name: 'Our Great Project',
               description: 'Sensible description goes here'

Project.create owner: project_owner, name: 'Second Great Project',
               description: 'Sensible description goes here'

Project.create owner: project_owner, name: 'Third Great Project',
               description: 'Sensible description goes here'

Project.all.each do |project|
  project.start

  project.add_user_comment project_owner, 'This is a comment from the project owner'
  project.add_user_comment other_user, 'This is a comment from another user'

  project.suspend
end
