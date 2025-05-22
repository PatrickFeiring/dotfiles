; extends

((macro_invocation
	(scoped_identifier
		path: (identifier) @path (#eq? @path "sqlx")
		name: (identifier) @name (#eq? @name "query_as"))

  (token_tree
		(raw_string_literal) @injection.content
			(#set! injection.language "sql")
			(#offset! @injection.content 3 0 -2 0)
			(#set! injection.include-children)
	)
))
