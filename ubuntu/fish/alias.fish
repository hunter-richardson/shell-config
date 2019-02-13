#!/usr/bin/fish

balias albert 'command albert show'
balias copy 'command xset -b --input'
balias cp 'command scp -v'
balias cpdir 'command scp -rv'
balias datetime 'builtin test -n $argv[1]; and builtin set -l format $argv[1]; and builtin set -e argv[1]; or builtin set -l format "now"; command date "+%a %e %b %Y, %H%M %Z" -d $format'
balias dtrx 'command dtrx -v --one-entry inside'
balias egrep 'command egrep --color=auto'
balias errcode 'strerror'
balias fgrep 'command fgrep --color=auto'
balias fix 'fuck'
balias grep 'command grep --color=auto'
balias ls 'command ls -AhHl --file-type --time-style="+%a %e %b %Y, %H%M %Z" --color=auto'
balias mkdir 'command mkdir -pv'
balias nano 'command nano -AEiSU --tabsize=2 --softwrap'
balias now 'command date "+%H%M %Z" -d now'
balias opsystem "builtin printf '%s ' (command cat /etc/os-release | command head -2 | builtin string split '\"')[2]"
balias paste 'command xset -b --output'
balias parent 'test -z $argv[1]; and dirname (pwd); or dirname $argv[1]'
balias rm 'command srm -v'
balias rmdir 'command srm -rv'
balias share 'command pastebinit'
balias shrug 'builtin echo "¯\_(ツ)_/¯"'
balias speak 'spd-say'
balias today 'command date "+%a %e %b %Y" -d today'
balias tomorrow 'command date "+%a %e %b %Y" -d tomorrow'
balias yesterday 'command date "+%a %e %b %Y" -d yesterday'
balias @google 'command googler -n 9 -l en-us'
balias @amazon '@google -w amazon.com'
balias @alternatives '@google -w alternativeto.net'
balias @android-dev '@google -w developer.android.com'
balias @askubuntu '@google -w askubuntu.com'
balias @bbc '@google -w bbc.co.uk'
balias @britannica '@google -w britannica.com'
balias @cb '@google -w crunchbase.com'
balias @chrome '@google -w chrome.google.com'
balias @craigslist '@google -w craigslist.org'
balias @cross '@google -w lxr.free-electrons.com'
balias @cnn '@google -w cnn.com'
balias @cpp '@google -w en.cppreference.com'
balias @dictionary '@google -w dictionary.com/browse'
balias @distrowatch '@google -w distrowatch.com'
balias @define '@google -w en.wikipedia.org/wiki -w en.oxforddictionaries.com -w merriam-webster.com/dictionary -w dictionary.com/browse -w thefreedictionary.com -w yourdictionary.com -w urbandictionary.com'
balias @etsy '@google -w etsy.com'
balias @etymology '@google -w etymonline.com'
balias @fandango '@google -w fandango.com'
balias @firefox '@google -w addons.mozilla.org'
balias @forbes '@google -w forbes.com'
balias @freedictionary '@google -w thefreedictionary.com'
balias @github '@google -w github.com'
balias @gnome '@google -w gnome.org'
balias @gnu '@google -w gnu.org'
balias @gnupg '@google -w gnupg.org'
balias @had '@google -w hackaday.com'
balias @ieee '@google -w ieee.org'
balias @ietf '@google -w ietf.org'
balias @ietf-data '@google -w datatracker.ietf.org'
balias @ig '@google -w instagram.com'
balias @imdb '@google -w imdb.com'
balias @khan '@google -w khanacademy.org'
balias @linkedin '@google -w linkedin.com'
balias @linux '@google -w linux.com'
balias @linux-questions '@google -w linuxquestions.org'
balias @linus-questions-wiki '@google -w wiki.linuxquestions.org'
balias @lucky '@google -j'
balias @man '@google -w manpages.ubuntu.com'
balias @man7 '@google -w man7.org'
balias @merriam '@google -w merriam-webster.com/dictionary'
balias @music 'mpsyt set show_video false / '
balias @news 'google -N'
balias @ocw '@google -w ocw.mit.edu'
balias @omg '@google -w omgubuntu.co.uk'
balias @opensource '@google -w opensource.com'
balias @open-alts '@google -w osalt.com'
balias @osdev '@google -w wiki.osdev.org'
balias @oxford '@google -w en.oxforddictionaries.com'
balias @patent '@google -w patents.google.com'
balias @play '@google -w play.google.com'
balias @playonlinux '@google -w playonlinux.com'
balias @plus '@google -w plus.google.com'
balias @python '@google -w docs.python.org'
balias @quora '@google -w quora.com'
balias @reddit '@google -w reddit.com'
balias @sourceforge '@google -w sourceforge.net'
balias @stackoverflow '@google -w stackoverflow.com'
balias @steam '@google -w store.steampowered.com'
balias @thesaurus '@google -w thesaurus.com'
balias @ted '@google -w ted.com'
balias @tldp '@google -w tldp.org'
balias @torrenz '@google -w torrentz2.eu'
balias @tomatoes '@google -w rottentomatoes.com'
balias @ubuntuforums '@google -w ubuntuforums.org'
balias @ubuntupackages '@google -w packages.ubuntu.com'
balias @urbandictionary '@google -w urbandictionary.com'
balias @uwiki '@google -w wiki.ubuntu.com'
balias @wikipedia '@google -w en.wikipedia.org'
balias @wikiquote '@google -w en.wikiquote.org'
balias @weather '@google -w weather.com'
balias @wikia '@google -w wikia.com'
balias @xgoogle '@google -x'
balias @xkcd '@google -w xkcd.com'
balias @youtube 'mpsyt set show_video true / '
balias @yourdictionary '@google -w yourdictionary.com'
