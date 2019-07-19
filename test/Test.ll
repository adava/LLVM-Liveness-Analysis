; ModuleID = 'Test.c'
source_filename = "Test.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local void @test1(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f) #0 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %c.addr = alloca i32, align 4
  %d.addr = alloca i32, align 4
  %e.addr = alloca i32, align 4
  %f.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32 %c, i32* %c.addr, align 4
  store i32 %d, i32* %d.addr, align 4
  store i32 %e, i32* %e.addr, align 4
  store i32 %f, i32* %f.addr, align 4
  %0 = load i32, i32* %c.addr, align 4
  %add = add nsw i32 %0, 11
  store i32 %add, i32* %a.addr, align 4
  %1 = load i32, i32* %f.addr, align 4
  %2 = load i32, i32* %e.addr, align 4
  %mul = mul nsw i32 %1, %2
  store i32 %mul, i32* %b.addr, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %3 = load i32, i32* %a.addr, align 4
  %4 = load i32, i32* %b.addr, align 4
  %cmp = icmp slt i32 %3, %4
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %5 = load i32, i32* %b.addr, align 4
  %6 = load i32, i32* %c.addr, align 4
  %mul1 = mul nsw i32 %5, %6
  store i32 %mul1, i32* %a.addr, align 4
  %7 = load i32, i32* %b.addr, align 4
  store i32 %7, i32* %d.addr, align 4
  %8 = load i32, i32* %d.addr, align 4
  %9 = load i32, i32* %c.addr, align 4
  %cmp2 = icmp sgt i32 %8, %9
  br i1 %cmp2, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  %10 = load i32, i32* %b.addr, align 4
  %add3 = add nsw i32 %10, 1
  store i32 %add3, i32* %b.addr, align 4
  br label %if.end

if.else:                                          ; preds = %while.body
  %11 = load i32, i32* %d.addr, align 4
  %12 = load i32, i32* %c.addr, align 4
  %mul4 = mul nsw i32 %11, %12
  store i32 %mul4, i32* %e.addr, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %13 = load i32, i32* %b.addr, align 4
  %14 = load i32, i32* %c.addr, align 4
  %mul5 = mul nsw i32 %13, %14
  store i32 %mul5, i32* %f.addr, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @test2(i32 %a, i32 %b, i32 %c, i32 %d, i32 %i) #0 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %c.addr = alloca i32, align 4
  %d.addr = alloca i32, align 4
  %i.addr = alloca i32, align 4
  %y = alloca i32, align 4
  %z = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32 %c, i32* %c.addr, align 4
  store i32 %d, i32* %d.addr, align 4
  store i32 %i, i32* %i.addr, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end5, %entry
  %0 = load i32, i32* %i.addr, align 4
  %cmp = icmp slt i32 %0, 100
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  store i32 210, i32* %a.addr, align 4
  %1 = load i32, i32* %c.addr, align 4
  %cmp1 = icmp sgt i32 %1, 20
  br i1 %cmp1, label %if.then, label %if.else4

if.then:                                          ; preds = %while.body
  store i32 200, i32* %a.addr, align 4
  %2 = load i32, i32* %d.addr, align 4
  %cmp2 = icmp slt i32 %2, 100
  br i1 %cmp2, label %if.then3, label %if.else

if.then3:                                         ; preds = %if.then
  store i32 101, i32* %d.addr, align 4
  br label %if.end

if.else:                                          ; preds = %if.then
  store i32 12000, i32* %c.addr, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then3
  store i32 510, i32* %b.addr, align 4
  br label %if.end5

if.else4:                                         ; preds = %while.body
  store i32 231, i32* %b.addr, align 4
  store i32 2544, i32* %c.addr, align 4
  store i32 2200, i32* %d.addr, align 4
  br label %if.end5

if.end5:                                          ; preds = %if.else4, %if.end
  %3 = load i32, i32* %a.addr, align 4
  %4 = load i32, i32* %b.addr, align 4
  %add = add nsw i32 %3, %4
  store i32 %add, i32* %y, align 4
  %5 = load i32, i32* %c.addr, align 4
  %6 = load i32, i32* %d.addr, align 4
  %add6 = add nsw i32 %5, %6
  store i32 %add6, i32* %z, align 4
  %7 = load i32, i32* %i.addr, align 4
  %add7 = add nsw i32 %7, 1
  store i32 %add7, i32* %i.addr, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @test3(i32 %a, i32 %b, i32 %d) #0 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %d.addr = alloca i32, align 4
  %e = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32 %d, i32* %d.addr, align 4
  %0 = load i32, i32* %a.addr, align 4
  %1 = load i32, i32* %b.addr, align 4
  %add = add nsw i32 %0, %1
  store i32 %add, i32* %e, align 4
  br label %do.body

do.body:                                          ; preds = %do.cond, %entry
  %2 = load i32, i32* %d.addr, align 4
  %3 = load i32, i32* %b.addr, align 4
  %add1 = add nsw i32 %2, %3
  store i32 %add1, i32* %d.addr, align 4
  %4 = load i32, i32* %e, align 4
  %sub = sub nsw i32 %4, 1
  store i32 %sub, i32* %e, align 4
  br label %do.cond

do.cond:                                          ; preds = %do.body
  %5 = load i32, i32* %e, align 4
  %cmp = icmp sgt i32 %5, 0
  br i1 %cmp, label %do.body, label %do.end

do.end:                                           ; preds = %do.cond
  %6 = load i32, i32* %d.addr, align 4
  %inc = add nsw i32 %6, 1
  store i32 %inc, i32* %d.addr, align 4
  ret void
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @test4(i32 %N, i32 %p, i32 %sum) #0 {
entry:
  %N.addr = alloca i32, align 4
  %p.addr = alloca i32, align 4
  %sum.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %N, i32* %N.addr, align 4
  store i32 %p, i32* %p.addr, align 4
  store i32 %sum, i32* %sum.addr, align 4
  store i32 0, i32* %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %0 = load i32, i32* %i, align 4
  %1 = load i32, i32* %N.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %2 = load i32, i32* %sum.addr, align 4
  %3 = load i32, i32* %p.addr, align 4
  %add = add nsw i32 %2, %3
  store i32 %add, i32* %sum.addr, align 4
  %4 = load i32, i32* %i, align 4
  %cmp1 = icmp sgt i32 %4, 3
  br i1 %cmp1, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  store i32 0, i32* %p.addr, align 4
  br label %if.end

if.else:                                          ; preds = %while.body
  %5 = load i32, i32* %p.addr, align 4
  %inc = add nsw i32 %5, 1
  store i32 %inc, i32* %p.addr, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %6 = load i32, i32* %i, align 4
  %inc2 = add nsw i32 %6, 1
  store i32 %inc2, i32* %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @test5(i32 %a, i32 %b, i32 %x, i32 %y, i32 %N) #0 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %x.addr = alloca i32, align 4
  %y.addr = alloca i32, align 4
  %N.addr = alloca i32, align 4
  %k = alloca i32, align 4
  %z = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32 %x, i32* %x.addr, align 4
  store i32 %y, i32* %y.addr, align 4
  store i32 %N, i32* %N.addr, align 4
  store i32 2, i32* %k, align 4
  %0 = load i32, i32* %a.addr, align 4
  %1 = load i32, i32* %N.addr, align 4
  %mul = mul nsw i32 %1, 2
  %cmp = icmp slt i32 %0, %mul
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %2 = load i32, i32* %k, align 4
  %add = add nsw i32 %2, 2
  store i32 %add, i32* %a.addr, align 4
  store i32 5, i32* %x.addr, align 4
  br label %if.end

if.else:                                          ; preds = %entry
  %3 = load i32, i32* %k, align 4
  %mul1 = mul nsw i32 %3, 2
  store i32 %mul1, i32* %a.addr, align 4
  store i32 8, i32* %x.addr, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %4 = load i32, i32* %a.addr, align 4
  store i32 %4, i32* %k, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %5 = load i32, i32* %k, align 4
  %6 = load i32, i32* %N.addr, align 4
  %cmp2 = icmp slt i32 %5, %6
  br i1 %cmp2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  store i32 2, i32* %b.addr, align 4
  %7 = load i32, i32* %a.addr, align 4
  %8 = load i32, i32* %k, align 4
  %add3 = add nsw i32 %7, %8
  store i32 %add3, i32* %x.addr, align 4
  %9 = load i32, i32* %a.addr, align 4
  %10 = load i32, i32* %b.addr, align 4
  %mul4 = mul nsw i32 %9, %10
  store i32 %mul4, i32* %y.addr, align 4
  %11 = load i32, i32* %k, align 4
  %inc = add nsw i32 %11, 1
  store i32 %inc, i32* %k, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %12 = load i32, i32* %a.addr, align 4
  %13 = load i32, i32* %x.addr, align 4
  %add5 = add nsw i32 %12, %13
  store i32 %add5, i32* %z, align 4
  ret void
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  ret i32 0
}

attributes #0 = { noinline nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 9.0.0 (trunk 351520)"}
