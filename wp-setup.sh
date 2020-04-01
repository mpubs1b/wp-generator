### Set the theme name
THEME="sinai"

### Set the local development URL
LOCALDEV="sinaiboilerplate.local"

### Set the list of plugins to be activated
declare -a arr=("autodescription" "advanced-custom-fields" "classic-editor" "ewww-image-optimizer" "wp-asset-clean-up" "autoptimize" )

### Set the list of plugins to install but not activate (require further config)
declare -a twoarr=("two-factor" "easy-wp-smtp" "disable-comments")

wp scaffold _s ${THEME} --activate
cd wp-content/themes/${THEME}/
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

sed -i "" "wp_enqueue_script( \'${THEME}-navigation\'.*/\/\/wp_enqueue_script( '${THEME}-vendor-scripts', get_template_directory_uri() . '/assets/js/vendor.min.js', array(), '20151215', true );/g" functions.php

sed -i "" "wp_enqueue_script( \'sinai-skip-link-focus-fix.*/wp_enqueue_script( \'${THEME}-theme-custom-scripts\', get_template_directory_uri() . '/assets/js/custom.min.js', array('customize-preview'), '20151215', true );/g" functions.php

for i in "${arr[@]}"
do
    wp plugin install $i --activate
done
 
for i in "${twoarr[@]}"
do
    wp plugin install $i  
done
 
### uninstall unneeded plugins
wp plugin uninstall akismet
wp plugin uninstall hello

### mkdir wp-content/themes/sage
### git clone https://github.com/roots/sage.git wp-content/themes/sage
### wp theme activate sage/resources
### 
### cd wp-content/themes/sage
### npm install && npm audit fix
### yarn start

### composer create-project roots/sage

### uninstall unneeded themes
declare -a arr=("twentynineteen" "twentyseventeen" "twentysixteen" "twentytwenty")
for i in "${arr[@]}"
do
    wp theme delete $i
done
