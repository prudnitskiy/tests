#!/usr/bin/env python3

from flask import Flask, request

app = Flask(__name__)


@app.route("/", methods=['GET'])
def root():
    f = request.args.get('f', None)

    try:
        f = int(f)
    # we'll check value later in calculateFactorial function
    except TypeError: pass
    except ValueError: pass

    if f is not None:
        factor, err = calculateFactorial(f)
        if err:
            return err, 503
        r = "factor for {0} == {1}".format(f, factor)
    else:
        r = "Use f GET param to calculate factorial"
    return r


@app.errorhandler(404)
def page_not_found(error):
    return "Not found", 404


def calculateFactorial(factor):
    if not isinstance(factor, int):
        return(None, 'Not a positive decimal number')
    if factor < 0:
        return(None, 'Factorial does not exsts for non-positive values')
    if factor == 0:
        return (1, None)
    for i in range(1, factor + 1):
        factor = factor * i

    return(factor, None)

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=False)
