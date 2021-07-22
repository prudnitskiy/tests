#!/usr/bin/env python3

import random


def displayRandomNumbers():
    a = []

    for i in range(1, 10):
        a.append(i)

    random.shuffle(a)
    for i in a:
        print(i)


if __name__ == "__main__":
    print("Displaying 10 random numbers")
    displayRandomNumbers()
