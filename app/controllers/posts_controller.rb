class PostsController < ApplicationController
  include CableReady::Broadcaster

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.order(created_at: :desc)
    @post = Post.new
  end

  # POST /posts
  # POST /posts.json
  def create
    post = Post.create({ username: 'tester' }.merge(post_params))
    cable_ready['timeline'].insert_adjacent_html(
      selector: "#timeline",
      position: 'afterbegin',
      html: render_to_string(partial: 'post', locals: { post: post })
    )
    cable_ready.broadcast
    redirect_to posts_path
  end

  private

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:body)
  end
end
