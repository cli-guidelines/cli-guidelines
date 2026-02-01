To record an example:

    $ docker-compose run clig scripts/docker-pull.sh

This will create a `.cast` file in `./out`.

To play a recording back:

    $ docker-compose run clig asciinema play out/docker-pull.cast

To convert a recording to SVG:

    $ docker-compose run clig sh -c "cat out/docker-pull.cast | svg-term --out out/docker-pull.svg"
