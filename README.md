**Summary**

In this phase of the project, we implemented liveness analysis algorithm. My implementation performs the analysis as follows: 

*   Construct the upward exposed and the killset sets for every block in UEVar method 
*   Traverse the CFG in Post Order and add the blocks to the worklist in PostOrderTraverse method 
*   In a loop, pop one block at a time from the worklist and perform LivenessAnalysis until the worklist is empty 
*   In the LivenessAnalysis method, call a function to construct the LiveOut set for a block and add the predecessors to the worklist if the liveout set is changed 
*   In the LiveOut function, construct the LiveOut set based on the following formula: 

LIVEOUT(b) = Union_(succ(b) as x)  (LIVEOUT (x) - VARKILL (x) + UEEXPR (x)) 

For the killset, upward exposed and liveout sets I use c++ map data structure, and I store variables as strings. I wrote my own custom difference and union functions to perform these operations because c+ + library functions for these operations did not work as expected. I ignore constant as I should because constant liveness wouldn’t make sense; compiler would use instructions immediate format for constants. I perform liveness on binary instructions, phi and icmp. Branch was not considered because the operand to branch instructions is label not variable (assuming that there is no indirect jump). 

**Execution instructions**

           cd [PATH-TO-CODE-FOLDER]/Pass/build/ cmake -DCMAKE_BUILD_TYPE=Release ../Transforms/LV/ make -j4 cd cd [PATH-TO-CODE-FOLDER]/test clang -Xclang -disable-O0-optnone Test.c -O0 -S -emit-llvm -o Test.ll;opt Test.ll -mem2reg -S -o Test.bc cd - 
           opt -load ../Pass/build/libLiveness.so -Liveness < Test.bc > /dev/null 

**Output Sample**

![](https://github.com/adava/LLVM-Liveness-Analysis/raw/master/test/test5.png)

-----------Function name: test5----------- 

entry: 

%mul = mul nsw i32 %N, 2 

%cmp = icmp slt i32 %a, %mul 

br i1 %cmp, label %if.then, label %if.else 

if.then: 

%add = add nsw i32 2, 2 

br label %if.end 

if.else: 

%mul1 = mul nsw i32 2, 2 

br label %if.end 

if.end: 

%x.addr.0 = phi i32 \[ 5, %if.then \], \[ 8, %if.else \] 

br label %while.cond 

while.cond: 

%k.0 = phi i32 \[ 4, %if.end \], \[ %inc, %while.body \] 

%x.addr.1 = phi i32 \[ %x.addr.0, %if.end \], \[ %add3, %while.body \] 

%cmp2 = icmp slt i32 %k.0, %N 

br i1 %cmp2, label %while.body, label %while.end 

while.body: 

%add3 = add nsw i32 4, %k.0 

%mul4 = mul nsw i32 4, 2 

%inc = add nsw i32 %k.0, 1 

br label %while.cond 

while.end: 

%add5 = add nsw i32 4, %x.addr.1 

ret void 

---------LiveOut-begin---------- 

if.end: 

N, x.addr.0, add3, inc, 

while.cond: 

x.addr.1, N, x.addr.0, k.0, 

while.body: 

N, add3, x.addr.0, inc, 

entry: 

N, add3, inc, 

if.then:N, add3, inc, 

if.else: 

N, add3, inc, 

while.end: 

---------LiveOut-end----------
