module.exports = (grunt) ->

  grunt.initConfig

    # 익스텐션의 매니페스트 파일
    # `package.json`은 빌드에서 사용하지 않는다.
    manifest: grunt.file.readJSON 'src/manifest.json'

    clean:
      build: ['build', 'src/js', 'src/css', 'release']

    coffee:
      build:
        files: [
            expand: true
            cwd: 'src/coffee'
            src: ['**/*.coffee']
            dest: 'src/js'
            ext: '.js'
        ]

    less:
      develop:
        files: [
            expand: true
            cwd: 'src/less'
            src: ['*.less']
            dest: 'src/css'
            ext: '.css'
        ]

    copy:
      # 이미지와 CSS 파일을 빌드 디렉토리로 복사한다.
      build:
        files: [
            expand: true
            cwd: 'src'
            src: ['*.html', '*.json']
            dest: 'build'
          ,
            expand: true
            cwd: 'src/img'
            src: ['*.jpg', '*.png', '*.gif']
            dest: 'build/img'
          ,
            expand: true
            cwd: 'src/css'
            src: ['*.css']
            dest: 'build/css'
          ,
            expand: true
            cwd: 'src/font'
            src: ['*.woff', '*.woff2']
            dest: 'build/font'
          ,
            expand: true
            cwd: 'src/js'
            src: ['**/*.js']
            dest: 'build/js'
          ,
            expand: true
            cwd: 'src/vendor'
            src: ['*.js']
            dest: 'build/vendor'
        ]

    compress:
      # 빌드 디렉토리를 압축한 후 현재 버전을 붙여 `zip` 파일을 생성한다.
      # 웹 스토어에는 압축한 파일로 등록한다.
      release:
        options:
          archive: 'release/naver_endic_<%= manifest.version %>.zip'

        files: [
          expand: true
          cwd: 'build'
          src: ['**']
          dest: './'
        ]


  # NPM 태스크 로드
  grunt.loadNpmTasks task for task in [
    'grunt-contrib-clean'
    'grunt-contrib-copy'
    'grunt-contrib-less'
    'grunt-contrib-coffee'
    'grunt-contrib-compress'
  ]


  # 태스크 등록
  grunt.registerTask 'default', [
    'coffee'
    'less'
  ]
  
  # 빌드 디렉토리로 스크립트를 압축한다.
  grunt.registerTask 'build', [
    'clean'
    'default'
    'copy'
  ]
  
  # 빌드 후 서비스 배포를 위한 `zip` 파일을 생성한다.
  grunt.registerTask 'release', [
    'build'
    'compress'
  ]