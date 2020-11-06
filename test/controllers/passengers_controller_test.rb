# TODO/notes: these will be largely similar to drivers_controller_test.
# strategy: nail down the drivers test and then copy&paste, find&replace
# difference to keep in mind:
#   riders dont have a status toggle
#   others?
#
# Here are some options for re-routing
    # must_respond_with :ok
    # must_respond_with :server_error
    # must_respond_with :bad_request
    # must_respond_with :not_found

    # must_redirect_to "/books"


require "test_helper"

describe PassengersController do
  describe "index" do
    # Your tests go here
  end

  describe "show" do
    # Your tests go here
  end

  describe "new" do
    # Your tests go here
  end

  describe "create" do
    # Your tests go here
  end

  describe "edit" do
    # Your tests go here
  end

  describe "update" do
    # Your tests go here
  end

  describe "destroy" do
    # Your tests go here
  end
end
