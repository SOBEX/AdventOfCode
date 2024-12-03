from math import gcd
from functools import reduce

def extended_gcd(a, b):
    if a == 0:
        return b, 0, 1
    else:
        g, x, y = extended_gcd(b % a, a)
        return g, y - (b // a) * x, x

def chinese_remainder(n, a):
    sum = 0
    prod = reduce(lambda a, b: a*b, n)
    result = 0
    for n_i, a_i in zip(n, a):
        p = prod // n_i
        g, x, y = extended_gcd(p, n_i)
        if g == 1:
            result += a_i * y * p
            result %= prod
        else:
            if a_i % g:
                raise Exception('No solutions exist')
            p, n_i, a_i = p // g, n_i // g, a_i // g
            g, x, y = extended_gcd(p, n_i)
            result += a_i * y * p
            result %= prod
    return result

def lcm(a, b):
    return a * b // gcd(a, b)

def lcm_list(numbers):
    return reduce(lcm, numbers)

def solve_congruences(n, a, count):
    solution = chinese_remainder(n, a)
    lcm = lcm_list(n)
    return [solution + i*lcm for i in range(count)]

n = [3793,3929,4001,4007]
a = [0,0,0,0,0,0]
count = 3
print(solve_congruences(n, a, count))
#[0, 238920142622879, 477840285245758]
