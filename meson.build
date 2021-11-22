project('com.AshishS-1123.ViewR', 'vala', 'c')

subdir('src')
subdir('data')

deps = [
  dependency('gtk+-3.0')
]

meson.add_install_script('meson/post_install.py')

executable('com.AshishS-1123.ViewR',
           [src],
           dependencies: deps)
