project('com.AshishS-1123.ViewR', 'vala', 'c')

subdir('src')
subdir('data')

deps = [
  dependency('gtk+-3.0'),
  dependency('granite', version: '>= 6.0.0')
]

gnome = import('gnome')
asresources = gnome.compile_resources(
    'as-resources', 'data/assets.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

meson.add_install_script('meson/post_install.py')

executable('com.AshishS-1123.ViewR',
           [src],
           asresources,
           dependencies: deps)
