const path = require('path');
const outPath = path.join(__dirname);
const htmlPath = path.join(__dirname, "html");

module.exports = {
    externals: {
        jquery: true
    },
    entry: './js/main.js',
    // entry: {
    //     './js/main.js': [
    //         path.resolve(__dirname, 'js/generateHTML.js'),
    //         path.resolve(__dirname, 'js/ws.js'),
    //         path.resolve(__dirname, 'js/chart.js'),
    //         path.resolve(__dirname, 'js/xlinx.js'),
    //     ]
    // },
    mode:'production',
    // output: {
    //     filename: 'bundle.js',
    //     publicPath: '/assets/',
    //     path: path.resolve(__dirname, './wwwroot/assets/'),        
    // },
    output: {
        path: __dirname + '/dist',
        filename: 'bundle.js'
    },
    // output: {
    //     filename: '[name]',
    //     path: __dirname + '/dist'
    // },
    module: {
        
        rules: [
            // {
            //     test: /\.js$/,
            //     loader: 'babel-loader',
            //     exclude: /node_modules/,
            //     query: {
            //         presets: ['es2015']
            //     }
            // },
            {
                test: /\.(html)$/,
                use: {
                    loader: 'html-loader',
                    options: {
                        attrs: [':data-src']
                    }
                }
            },
            {
                test: /\.ttf$/,
                loaders: [
                    'url-loader'
                ]
            },
            { test: /\.css$/, use:  [
                    'style-loader',
                    'css-loader'
                ]
            },

            {
                test: /\.less$/,
                use: [{
                    loader: 'style-loader',
                }, {
                    loader: 'css-loader', // translates CSS into CommonJS
                }, {
                    loader: 'less-loader', // compiles Less to CSS
                    options: {
                        javascriptEnabled: true
                    },
                }]
            }]
    }
    ,devtool: 'source-map'
}
