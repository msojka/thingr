require 'test_helper'

class CommentCellTest < Cell::TestCase
  controller ThingsController

  let (:thing) do
    thing = Thing::Create.(thing: {name: "Rails"}).model

    Comment::Create.(comment: {body: "Excellent", weight: "0", user: {email: "zavan@trb.org"}}, id: thing.id)
    Comment::Create.(comment: {body: "!Well.", weight: "1", user: {email: "jonny@trb.org"}}, id: thing.id)
    Comment::Create.(comment: {body: "Cool stuff!", weight: "0", user: {email: "chris@trb.org"}}, id: thing.id)
    Comment::Create.(comment: {body: "Improving.", weight: "1", user: {email: "hilz@trb.org"}}, id: thing.id)

    thing
  end

  # the comment grid.
  # .(:show)
  it do
    html = concept("comment/cell/grid", thing).(:show)

    comments = html.all(:css, ".comment")
    comments.size.must_equal 3

    first = comments[0]
    first.must_have_content "hilz@trb.org"
    first.must_have_content "Improving"
    first.wont_have_selector(".fi-heart")
    first[:class].wont_match /\send/

    second = comments[1]
    second.must_have_content "chris@trb.org"
    second.must_have_content "Cool stuff!"
    second.must_have_selector(".fi-heart")
    second[:class].wont_match /\send/

    third = comments[2]
    third.must_have_content "jonny@trb.org"
    third.must_have_content "!Well."
    third.wont_have_selector(".fi-heart")
    third[:class].must_match /\send/ # last grid item.

    # "More!"
    html.find("#next a")["href"].must_equal "/things/#{thing.id}/next_comments?page=2"
  end

  # .(:append)
  it do
    html = concept("comment/cell/grid", thing, page: 2).(:append)

    # html.must_match /replaceWith/
    # html.must_match /zavan@trb.org/
  end
end