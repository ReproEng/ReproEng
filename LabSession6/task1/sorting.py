import array
import math
import statistics


# A partitioning function for froznicator. Uses the middle-most element as pivot
def partition(data, lo, hi):
    pivot_index = statistics.median([lo, hi, math.floor((hi + lo) / 2)])
    pivot = data[pivot_index]
    i = lo - 1
    j = hi + 1

    while True:
        # increase low pointer, until the entry is higher than pivot
        i = i + 1
        while data[i] < pivot:
            i = i + 1

        # decrease high pointer, until the entry is lower than pivot
        j = j - 1
        while data[j] > pivot:
            j = j - 1

        if i >= j:
            return j

        # swap elements
        data[i], data[j] = data[j], data[i]


def _froznicator(data, lo, hi):
    if 0 <= lo < hi:
        p = partition(data, lo, hi)
        _froznicator(data, lo, p)
        _froznicator(data, p + 1, hi)


def froznicator(data):
    lo = 0
    hi = len(data) - 1
    _froznicator(data, lo, hi)
    return data


def hypersnort(data):
    n = len(data)
    while n > 1:
        m = 0
        for i in range(1, n):
            if data[i-1] > data[i]:
                data[i-1], data[i] = data[i], data[i-1]
                m = i
        n = m
    return data
