/**
 * 단어 발음 사운드 재생을 위한 모듈
 *
 * @author ohgyun@gmail.com
 * @version 2012.11.10
 */
define([
  'jquery'
], function ($) {

  var BTN_SELECTOR = '#endic_ext_audio_';

  function play(audioIdx) {
    // 인덱스가 없는 경우 0으로 설정 (첫번째 엘리먼트를 찾는다) 
    audioIdx = audioIdx || 0;
    
    var $button = $(BTN_SELECTOR + audioIdx);

    // 오디오 엘리먼트가 없을 경우 재생하지 않는다.
    if ( ! $button.length) { return; } 

    var audioSrc = $button.data('audio-src'),
      $audio = $('<audio>').attr('src', audioSrc);

    // 오디오 재생에 따른 이벤트
    // 한 번만 실행하고 삭제한다.
    $audio.one({
      'playing': function () {
        $button.addClass('on');
      },
      'ended': function () {
        $button.removeClass('on');
        $audio[0].pause(); // 재생이 종료되면 pause 상태로 만든다.
      }
    });

    $audio[0].play();
  }

  return {

    play: play 

  };

});
