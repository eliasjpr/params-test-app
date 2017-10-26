- active = context.request.path == "/" ? "active" : ""
a class="nav-item #{active}" href="/" Home
- active = context.request.path == "/posts" ? "active" : ""
a class="nav-item #{active}" href="/posts" Posts
- if context.current_user
  a class="nav-item pull-right" href="/signout" Sign Out
  div.nav-item.pull-right == context.current_user.not_nil!.email
- else
  - active = context.request.path == "/signup" ? "active" : ""
  a class="nav-item #{active} pull-right" href="/signup" Sign Up
  - active = context.request.path == "/signin" ? "active" : ""
  a class="nav-item #{active} pull-right" href="/signin" Sign In
