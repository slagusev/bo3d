	format	MS COFF
	extrn	___bb_blitz_blitz
	extrn	___bb_bo3d_bo3d
	extrn	___bb_random_random
	extrn	_bbOnDebugEnterScope
	extrn	_bbOnDebugEnterStm
	extrn	_bbOnDebugLeaveScope
	extrn	_bbStringClass
	extrn	_sedm_bo3d_AntiAlias
	extrn	_sedm_bo3d_CameraClsColor
	extrn	_sedm_bo3d_CreateCamera
	extrn	_sedm_bo3d_CreateLight
	extrn	_sedm_bo3d_CreatePlane
	extrn	_sedm_bo3d_EndGraphics3D
	extrn	_sedm_bo3d_Graphics3D
	extrn	_sedm_bo3d_LoadMesh
	extrn	_sedm_bo3d_MouseHit
	extrn	_sedm_bo3d_MouseZSpeed
	extrn	_sedm_bo3d_PositionEntity
	extrn	_sedm_bo3d_RenderWorld
	extrn	_sedm_bo3d_TurnEntity
	extrn	_sedm_bo3d_WinTitle
	public	__bb_main
	section	"code" code
__bb_main:
	push	ebp
	mov	ebp,esp
	sub	esp,16
	push	ebx
	cmp	dword [_40],0
	je	_41
	mov	eax,0
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_41:
	mov	dword [_40],1
	mov	dword [ebp-4],0
	mov	dword [ebp-8],0
	mov	dword [ebp-12],0
	mov	dword [ebp-16],0
	push	ebp
	push	_33
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	___bb_blitz_blitz
	call	___bb_random_random
	call	___bb_bo3d_bo3d
	push	_9
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_2
	call	_sedm_bo3d_WinTitle
	add	esp,4
	push	_11
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	16
	call	_sedm_bo3d_AntiAlias
	add	esp,4
	push	_12
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	32
	push	600
	push	1024
	call	_sedm_bo3d_Graphics3D
	add	esp,16
	push	_13
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	call	_sedm_bo3d_CreateCamera
	add	esp,4
	mov	dword [ebp-4],eax
	push	_15
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1106247680
	push	1114636288
	push	1119092736
	push	dword [ebp-4]
	call	_sedm_bo3d_CameraClsColor
	add	esp,16
	push	_16
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	_3
	call	_sedm_bo3d_LoadMesh
	add	esp,8
	mov	dword [ebp-8],eax
	push	_18
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	1120403456
	push	1120403456
	push	0
	push	dword [ebp-8]
	call	_sedm_bo3d_PositionEntity
	add	esp,20
	push	_19
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	-1054867456
	push	0
	push	0
	push	dword [ebp-4]
	call	_sedm_bo3d_PositionEntity
	add	esp,20
	push	_20
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	2
	call	_sedm_bo3d_CreateLight
	add	esp,8
	mov	dword [ebp-12],eax
	push	_22
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	-1027080192
	push	1120403456
	push	-1027080192
	push	dword [ebp-12]
	call	_sedm_bo3d_PositionEntity
	add	esp,20
	push	_23
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	call	_sedm_bo3d_CreatePlane
	add	esp,4
	mov	dword [ebp-16],eax
	push	_25
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
_6:
	push	_26
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	1008981770
	push	0
	push	dword [ebp-8]
	call	_sedm_bo3d_TurnEntity
	add	esp,16
	push	_27
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1008981770
	push	1008981770
	push	1008981770
	push	dword [ebp-16]
	call	_sedm_bo3d_TurnEntity
	add	esp,16
	push	_28
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_sedm_bo3d_RenderWorld
	push	_29
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_sedm_bo3d_MouseZSpeed
	cmp	eax,0
	je	_30
	push	_31
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	jmp	_5
_30:
_4:
	push	1
	call	_sedm_bo3d_MouseHit
	add	esp,4
	cmp	eax,0
	je	_6
_5:
	push	_32
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_sedm_bo3d_EndGraphics3D
	mov	ebx,0
	jmp	_7
_7:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
	section	"data" data writeable align 8
	align	4
_40:
	dd	0
_34:
	db	"example01",0
_35:
	db	"cam",0
_36:
	db	"i",0
_37:
	db	"ogre",0
_38:
	db	"l",0
_39:
	db	"p",0
	align	4
_33:
	dd	1
	dd	_34
	dd	2
	dd	_35
	dd	_36
	dd	-4
	dd	2
	dd	_37
	dd	_36
	dd	-8
	dd	2
	dd	_38
	dd	_36
	dd	-12
	dd	2
	dd	_39
	dd	_36
	dd	-16
	dd	0
_10:
	db	"$BMXPATH/mod/sedm.mod/bo3d.mod/example/example01.bmx",0
	align	4
_9:
	dd	_10
	dd	4
	dd	1
	align	4
_2:
	dd	_bbStringClass
	dd	2147483647
	dd	9
	dw	98,111,51,68,32,48,46,49,56
	align	4
_11:
	dd	_10
	dd	5
	dd	1
	align	4
_12:
	dd	_10
	dd	7
	dd	1
	align	4
_13:
	dd	_10
	dd	8
	dd	1
	align	4
_15:
	dd	_10
	dd	9
	dd	1
	align	4
_16:
	dd	_10
	dd	11
	dd	1
	align	4
_3:
	dd	_bbStringClass
	dd	2147483647
	dd	19
	dw	109,101,100,105,97,92,111,103,114,101,104,101,97,100,46,109
	dw	101,115,104
	align	4
_18:
	dd	_10
	dd	12
	dd	1
	align	4
_19:
	dd	_10
	dd	13
	dd	1
	align	4
_20:
	dd	_10
	dd	15
	dd	1
	align	4
_22:
	dd	_10
	dd	16
	dd	1
	align	4
_23:
	dd	_10
	dd	18
	dd	1
	align	4
_25:
	dd	_10
	dd	26
	dd	1
	align	4
_26:
	dd	_10
	dd	21
	dd	2
	align	4
_27:
	dd	_10
	dd	22
	dd	2
	align	4
_28:
	dd	_10
	dd	23
	dd	2
	align	4
_29:
	dd	_10
	dd	25
	dd	2
	align	4
_31:
	dd	_10
	dd	25
	dd	24
	align	4
_32:
	dd	_10
	dd	28
	dd	1
