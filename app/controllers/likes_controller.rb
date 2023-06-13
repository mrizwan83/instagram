class LikesController < ApplicationController
    before_action :set_post
    def toggle_like
        if(@like = @post.likes.find_by(user: current_user))
            @like.destroy
        else
            @post.likes.create(user: current_user)
        end

        respond_to do |format|
            format.turbo_stream do 
                render turbo_stream: turbo_stream.replace(
                    "post#{@post.id}actions",
                    partial: "posts/post_actions",
                    locals: {post: @post}
                )
            end
        end
    end

    private
    def set_post
        @post = Post.find(params[:post_id])
    end
end

# added backend for turbo to likes controller to allow for replacement 
# when it compares the sections and if has changed it will automaticaly replace and rerender without refreshing the page
# so if i want to make single page applications later i will need to use turbo stream to append/prepend or replace info within a tag specified by the id
# along with turbo frame which will rerender without refreshing the page if something has changed