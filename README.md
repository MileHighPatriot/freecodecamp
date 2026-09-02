# freeCodeCamp

All freeCodeCamp GitHub saves live **here**, in `labs/`, not as separate repos mixed with games and sites.

FCC’s **Save to GitHub** button always creates a new top-level repo. After you save a lab, tell Grok **pull fcc** (or run the script below). It copies that repo into `labs/<name>/` and archives the leftover standalone repo so it drops off your main GitHub list.

## Labs

- [html-video-player](labs/html-video-player/) — Responsive Web Design workshop
- [html-audio-and-video-player](labs/html-audio-and-video-player/) — Responsive Web Design lab

## After FCC saves a new repo

```bash
cd ~/freecodecamp
bash scripts/collect-fcc.sh
git add labs && git commit -m "Add FCC lab" && git push
```

Or in Grok Build: **pull fcc**.

## Links

- GitHub: https://github.com/MileHighPatriot/freecodecamp
- Origin: https://cursor.com/codebase/milehigh-patriot/freecodecamp
- Live: https://milehighpatriot.github.io/freecodecamp/
