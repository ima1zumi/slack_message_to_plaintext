# frozen_string_literal: true

require "uri"

class Text
  # 発言者の名前を削除
  def self.delete_name(message, argv)
    n = argv[0].chomp
    message.delete_if { _1.match?(/\A#{n}/) }
  end

  # 2つ以上の改行コードを1つの改行コードになるまで削除
  def self.delete_two_or_more_newline_code(message)
    text = message.dup
    text.delete_if.with_index do |str, i|
      next if i == message.size - 1
      message[i].match?(/\A\n\z/) && message[i+1].match?(/\A\n\z/)
    end
  end

  # reactionとreactionがついた数を削除
  def self.delete_reaction_emoji_and_reaction_number(message)
    emoji = false
    text = message.dup
    text.delete_if do |str|
      if str.match?(/\A:.*:\Z/)
        emoji = true
        true
      elsif emoji && str.match?(/\A[1-9][0-9]*\Z/)
        emoji = false
        true
      end
    end
  end

  # （編集済み）の文字列を削除
  def self.delete_edited(message)
    message.map do |str|
      if str.match?(/（編集済み）/)
        str.gsub(/（編集済み）/, "")
      else
        str
      end
    end
  end

  # URLの後に入る文字列を削除（バグってる）
  def self.delete_urltenkai(message)
    urltenkai = false
    text = message.dup
    text.delete_if do |str|
      if URI.regexp.match?(str) # URLにマッチしない
        urltenkai = true
        false
      elsif str.match?(/\A\n\z/) && urltenkai
        urltenkai = false
        false
      elsif urltenkai
        true
      end
    end
  end

  def self.delete_all(message, argv)
    message = delete_name(message, argv)
    message = delete_two_or_more_newline_code(message)
    message = delete_reaction_emoji_and_reaction_number(message)
    message = delete_edited(message)
    message = delete_urltenkai(message)
  end
end
