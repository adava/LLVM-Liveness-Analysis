
void test1(int a, int b, int c, int d, int e, int f) {
    a = c + 11;
    b = f * e;
    while (a < b) {
        a = b * c;
        d = b;
        if (d > c)
            b = b + 1;
        else
            e = d * c;
        f = b * c;
    }
}

void test2(int a, int b, int c, int d, int i) {
    while (i < 100) {
        a = 210;
        if (c > 20) {
            a = 100 * 2;
            if (d < 100) {
                d = 101;
            } else {
                c = 100 * 120;
            }
            b = 300 + 210;
        } else {
            b = 21 + 210;
            c = 212 * 12;
            d = 200 * 11;
        }
        int y = a + b;
        int z = c + d;
        i = i + 1;
    }
}

void test3(int a, int b, int d) {
    int e = a + b;
    do {
        d = d + b;
        e = e - 1;
    } while (e > 0);
    d++;
}

void test4(int N, int p, int sum) {
    int i = 0;
    while (i < N) {
        sum = sum + p;
        if (i > 3)
            p = 0;
        else
            p++;
        i++;
    }
}

void test5(int a, int b, int x, int y, int N) {
    int k = 2;
    if (a < N * 2) {
        a = k + 2;
        x = 5;
    } else {
        a = k * 2;
        x = 8;
    }
    k = a;
    while (k < N) {
        b = 2;
        x = a + k;
        y = a * b;
        k++;
    }
    int z = a + x;
}

int main(int argc, char** argv) {
	//test(10, 11, 25, 33, 43,26);
//    test1(10, 11, 25, 33, 43,26, 44);
  return 0;
}