#!/usr/bin/env ruby
eval main=<<'MAIN'

# generate_oracle.rb
require './vigenere.rb'
require './fifth_page.rb'
require './password.rb'

ORACLE_PERIOD_LENGTH = 6 * 60 * 60  # 6 hours
period = Time.now.to_i / ORACLE_PERIOD_LENGTH
remote_addr = (ENV['REMOTE_ADDR']||'0').split('.').inject(0){|r,i| r*256+i.to_i}

oracle_number = (period << 32 + remote_addr) % $oracles.size
oracle = $oracles[oracle_number]

raise "fake oracle" unless $plain_text.include?(oracle)

$template =<<TEMPLATE
Content-type: text/html; charset=utf-8

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="utf-8">
<title>decode the answer | Code Puzzle</title>
</head>
<body>
<div style="text-align: center; padding: 40px 0">
  <code>$plain_text contains: ...#{oracle}...</code>
</div>
<div style="text-align: right"><small>#{period}th period</small></div>
<div style="text-align: center; padding: 20px 0">
  <a href="https://twitter.com/share" class="twitter-share-button" data-url="http://cp1.nintendo.co.jp/ruby.html" data-text="&quot;$plain_text contains: ...#{oracle}...&quot;" data-lang="ja" data-size="large" data-count="none" data-hashtags="codepuzzle" data-dnt="true">Tweet</a>
  <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
</div>
<hr />
<textarea style="width: 100%; height: 800px">
%QUINE%
</textarea>
</body>
</html>
TEMPLATE

def escape(str)
  entity_refs = Hash[*%w(& &amp; < &lt; > &gt; " &quot;)]
  str.gsub(/[#{entity_refs.keys.join}]/){|sym| entity_refs[sym]}
end

MAIN
eval quine="puts $template.sub('%QUINE%', escape((%(#!/usr/bin/env ruby\neval main=<<'MAIN'\n) + main + %(MAIN\neval quine=) + quine.inspect)))"
