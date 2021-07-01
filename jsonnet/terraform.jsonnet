function(libs, pages=false) {
  'tf/main.tf.json':
    std.manifestJsonEx(
      {
        '//': 'Generated by `make configure`, please do not edit manually.',
        terraform: {
          required_providers: {
            github: {
              source: 'integrations/github',
              version: '~>4.0',
            },
          },
          backend: {
            remote: {
              organization: 'jsonnet-libs',
              workspaces: {
                name: 'jsonnet-libs',
              },
            },
          },
        },
        provider: {
          github: { owner: 'jsonnet-libs' },
        },
      }
      + std.foldl(
        function(acc, lib)
          acc {
            resource+:
              [{
                github_repository: {
                  [lib.name]: {
                    name: lib.name + lib.suffix,
                    description: lib.description,
                    homepage_url: lib.site_url,
                    topics: ['jsonnet', 'jsonnet-libs'],
                    auto_init: true,
                    has_downloads: false,
                    has_issues: false,
                    has_projects: false,
                    has_wiki: false,
                    allow_merge_commit: false,
                    allow_rebase_merge: false,
                    lifecycle: {
                      ignore_changes: ['pages'],
                    },
                  } + (
                    if pages
                    then {
                      lifecycle: {
                        ignore_changes: [],
                      },
                      pages:
                        {
                          source:
                            {
                              branch: 'gh-pages',
                              path: '/',
                            },
                        },
                    }
                    else {}
                  ),
                },
              }],
          },
        libs,
        {}
      )
      , '  '
    ),
}
