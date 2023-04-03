# Specs

## Original task

Use Ruby on Rails to build a project conversation history. A user should be able to:

* leave a comment
* change the status of the project
  The project conversation history should list comments and changes in status.
  Please don’t spend any more than 3 hours on this task.

## Assumptions

To simulate what would happen in a real life scenario for a developer who is already working on 
a project, I will make the following assumptions about things that I shouldn’t have to ask a 
colleague, because I would already know them, or because I could learn them from the codebase

* The Project model already exists, and it includes a “status” string field. The allowed transitions are also already defined. This is the list of available statuses, with the 
* possible transitions which are available from it:
  * New => InProgress, Canceled
  * InProgress => Suspended, Completed, Canceled
  * Suspended => InProgress, Canceled
  * Completed => none (final status)
  * Canceled => none (final status)
* A page to view a project (#show action) is already available
* There is currently no model for comments on a project
* There is currently no history stored for changes on a project status

## Questions & Answers

* Where should the conversation history be visible?
    * Directly in the “show” page for the project, below all other current data
* Where should a user be able to add comments?
    * From the “show” page for the project
* What kind of content should be available for comments?
    * Unformatted text only
* Should comments be threaded?
    * No, flat
* Should it be possible to mention another user in a comment? Should the mentioned user be notified in that case?
    * Out of scope for this iteration.
* Should it be possible to edit and delete a comment for the author?
    * Yes [didn't have time to implement this in the time given]
* Should anybody be notified when a comment gets added?
    * Yes, the owner of the project should receive an email notification [not implemented]
* Who should be able to add a comment?
    * Any registered user
* Who should be able to change the status of a project?
    * Only the owner of the project
* Where should the user be able to change the status of the project?
    * From the “show” page from the project. Add a button “Change Status” near the current status. The user should be able to choose the new status among the statuses which the current one can transition to
* Should anybody be notified when the status of the project changes?
    * Nobody

## Future improvements

Given more time I would:

* Add system tests for the user using the interface
* Add delete/edit for comments
* Add email notifications for comments
* Add pagination for project history items
* Add a “mention” feature for comments, so that users can be notified when they are mentioned
* Add a “reply” feature for comments, so that users can reply to a specific comment

# Usage - local

## Installation

Prerequisite is to have Ruby 3.2 installed and a local postgresql database which
allows local connections without a password.

* bundle install
* rake db:drop [to make sure there wasn't a previous database]
* rake db:create
* rake db:setup

## Running the web server

* rails s

## Manual tests

* open http://localhost:3000

* Log in as project owner: project_owner@test.com/project_owner
* Log in as a normal user: other_user@test.com/other_user

* Click on any project
* Add comments as you like
* As a project owner, you can also change the project status
  * NB if you "cancel" or "complete" the project, you will not be able to change it back 

You can open two different browsers, or an incognito window, to log in as both users at the same
time ans see the real-time updates.

## Running the automated tests

* Tests are built with RSpec, so you can run them with `rspec`

# Usage - Docker

## Installing and running the web server

* docker compose build
* docker compose run web bin/rails db:drop db:setup
* docker compose up

The server is available at http://localhost:3000


