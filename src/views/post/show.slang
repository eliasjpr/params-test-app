p = post.title
p = post.body
p = post.published
p
  a.btn.btn-default.btn-xs href="/posts" back
  a.btn.btn-success.btn-xs href="/posts/#{ post.id }/edit" edit
  a.btn.btn-danger.btn-xs href="/posts/#{ post.id }?_method=delete" onclick="return confirm('Are you sure?');" delete
