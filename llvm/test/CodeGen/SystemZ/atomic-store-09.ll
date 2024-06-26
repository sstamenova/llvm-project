; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 4
; Test long double atomic stores on z14.
;
; RUN: llc < %s -mtriple=s390x-linux-gnu -mcpu=z14 | FileCheck %s

define void @f1(ptr %dst, ptr %src) {
; CHECK-LABEL: f1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lg %r1, 8(%r3)
; CHECK-NEXT:    lg %r0, 0(%r3)
; CHECK-NEXT:    stpq %r0, 0(%r2)
; CHECK-NEXT:    bcr 14, %r0
; CHECK-NEXT:    br %r14
  %val = load fp128, ptr %src, align 8
  store atomic fp128 %val, ptr %dst seq_cst, align 16
  ret void
}

define void @f1_fpsrc(ptr %dst, ptr %src) {
; CHECK-LABEL: f1_fpsrc:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl %v0, 0(%r3), 3
; CHECK-NEXT:    wfaxb %v0, %v0, %v0
; CHECK-NEXT:    vlgvg %r1, %v0, 1
; CHECK-NEXT:    vlgvg %r0, %v0, 0
; CHECK-NEXT:    stpq %r0, 0(%r2)
; CHECK-NEXT:    bcr 14, %r0
; CHECK-NEXT:    br %r14
  %val = load fp128, ptr %src, align 8
  %add = fadd fp128 %val, %val
  store atomic fp128 %add, ptr %dst seq_cst, align 16
  ret void
}

define void @f2(ptr %dst, ptr %src) {
; CHECK-LABEL: f2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    stmg %r14, %r15, 112(%r15)
; CHECK-NEXT:    .cfi_offset %r14, -48
; CHECK-NEXT:    .cfi_offset %r15, -40
; CHECK-NEXT:    aghi %r15, -176
; CHECK-NEXT:    .cfi_def_cfa_offset 336
; CHECK-NEXT:    vl %v0, 0(%r3), 3
; CHECK-NEXT:    lgr %r0, %r2
; CHECK-NEXT:    la %r4, 160(%r15)
; CHECK-NEXT:    lghi %r2, 16
; CHECK-NEXT:    lgr %r3, %r0
; CHECK-NEXT:    lhi %r5, 5
; CHECK-NEXT:    vst %v0, 160(%r15), 3
; CHECK-NEXT:    brasl %r14, __atomic_store@PLT
; CHECK-NEXT:    lmg %r14, %r15, 288(%r15)
; CHECK-NEXT:    br %r14
  %val = load fp128, ptr %src, align 8
  store atomic fp128 %val, ptr %dst seq_cst, align 8
  ret void
}

define void @f2_fpuse(ptr %dst, ptr %src) {
; CHECK-LABEL: f2_fpuse:
; CHECK:       # %bb.0:
; CHECK-NEXT:    stmg %r14, %r15, 112(%r15)
; CHECK-NEXT:    .cfi_offset %r14, -48
; CHECK-NEXT:    .cfi_offset %r15, -40
; CHECK-NEXT:    aghi %r15, -176
; CHECK-NEXT:    .cfi_def_cfa_offset 336
; CHECK-NEXT:    vl %v0, 0(%r3), 3
; CHECK-NEXT:    wfaxb %v0, %v0, %v0
; CHECK-NEXT:    lgr %r0, %r2
; CHECK-NEXT:    la %r4, 160(%r15)
; CHECK-NEXT:    lghi %r2, 16
; CHECK-NEXT:    lgr %r3, %r0
; CHECK-NEXT:    lhi %r5, 5
; CHECK-NEXT:    vst %v0, 160(%r15), 3
; CHECK-NEXT:    brasl %r14, __atomic_store@PLT
; CHECK-NEXT:    lmg %r14, %r15, 288(%r15)
; CHECK-NEXT:    br %r14
  %val = load fp128, ptr %src, align 8
  %add = fadd fp128 %val, %val
  store atomic fp128 %add, ptr %dst seq_cst, align 8
  ret void
}
