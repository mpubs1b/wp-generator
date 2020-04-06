### Set the theme names
PARENT_THEME="underscores-sinai"
THEME="sinai"

### Set the local development URL
LOCALDEV="sinaiboilerplate.local"

### Set the list of plugins to be activated
declare -a pluginsActivate=("autodescription" "advanced-custom-fields" "classic-editor" "ewww-image-optimizer" "wp-asset-clean-up" "autoptimize" )

### Set the list of plugins to install but not activate (require further config)
declare -a pluginsForConfig=("two-factor" "easy-wp-smtp" "disable-comments")

### Set the list of unneeded themes to uninstall
declare -a arr=("twentynineteen" "twentyseventeen" "twentysixteen" "twentytwenty")

### Create a child theme based on Underscores
wp scaffold _s ${PARENT_THEME} --theme_name="${PARENT_THEME}"

cd wp-content/themes/${PARENT_THEME}/
npx wpgulp
sed -i "" "s/wpgulp.local/${LOCALDEV}/g" wpgulp.config.js

mkdir -p assets/css assets/js/vendor assets/js/custom assets/img/raw
mv style.css assets/css/style.scss
mv layouts/ assets/css/layouts
mv assets/css/layouts/sidebar-content.css assets/css/layouts/sidebar-content.scss
mv assets/css/layouts/content-sidebar.css assets/css/layouts/content-sidebar.scss
mv js/customizer.js assets/js/custom/customizer.js
mv js/navigation.js assets/js/custom/navigation.js
mv js/skip-link-focus-fix.js assets/js/custom/skip-link-focus-fix.js
rm -R js/

sed -i "" "s#wp_enqueue_script( '${PARENT_THEME}-navigation'.*#//wp_enqueue_script( '${THEME}-vendor-scripts', get_template_directory_uri() . '/assets/js/vendor.min.js', array(), '20151215', true );#g" functions.php

sed -i "" "s#wp_enqueue_script( '${PARENT_THEME}-skip-link-focus-fix.*#wp_enqueue_script( '${THEME}-theme-custom-scripts', get_template_directory_uri() . '/assets/js/custom.min.js', array('customize-preview'), '20151215', true );#g" functions.php

sed -i "" "s#imagemin.jpegtran({ progressive: true }),#imagemin.mozjpeg({progressive: true,}),#g" gulpfile.babel.js

npm install 	
npm install gulp babel-register babel-core @babel/preset-env gulp-sass gulp-uglifycss gulp-autoprefixer gulp-merge-media-queries gulp-rtlcss gulp-concat gulp-uglify gulp-babel @babel/core gulp-imagemin gulp-rename gulp-line-ending-corrector gulp-filter gulp-concat gulp-cache gulp-wp-pot gulp-sourcemaps gulp-remember gulp-rename gulp-sort gulp-plumber gulp-notify beepbeep @babel/preset-env
npm link gulp gulp-sass gulp-uglifycss gulp-autoprefixer gulp-merge-media-queries gulp-rtlcss gulp-concat gulp-uglify gulp-babel @babel/core gulp-imagemin gulp-rename gulp-line-ending-corrector gulp-filter gulp-concat gulp-cache gulp-wp-pot gulp-sourcemaps gulp-remember gulp-rename gulp-plumber gulp-notify browser-sync beepbeep gulp-sort @babel/preset-env
npm audit fix

wp scaffold child-theme ${THEME} --parent_theme=${PARENT_THEME} --activate

for i in "${pluginsActivate[@]}"
do
    wp plugin install $i --activate
done
 
for i in "${pluginsForConfig[@]}"
do
    wp plugin install $i  
done
 
### uninstall unneeded plugins
wp plugin uninstall akismet
wp plugin uninstall hello

for i in "${arr[@]}"
do
    wp theme delete $i
done
