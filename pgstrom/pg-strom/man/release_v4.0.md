@ja:#PG-Strom v4.0�����[�X
@en:#PG-Strom v4.0 Release

<div style="text-align: right;">PG-Strom Development Team (xx-xxx-2021)</div>

@ja:##�T�v
@en:##Overview

@ja{
PG-Strom v4.0�ɂ������v�ȕύX�͓_�͈ȉ��̒ʂ�ł��B

@ja{
- GpuPreAgg��GPU����������V���A���ɃO���[�v���������ꍇ�̏������x�����サ�܂����B
- Arrow_Fdw��min/max���v�l��p�����͈̓C���f�b�N�X�X�L�����ɑΉ����܂����B
- Pg2Arrow��min/max���v�l�t����Arrow�t�@�C���o�͂ɑΉ����܂����B
- �l�b�g���[�N�p�P�b�g���L���v�`������Pcap2Arrow�c�[����ǉ����܂����B
- HyperLogLog�A���S���Y����p�����J�[�f�B�i���e�B�̐���ɑΉ����܂����B

- PostgreSQL v14�ɑΉ����܂����B

- todo: GPU-Direct SQL�ŁA�폜�ς݃^�v�����܂ރu���b�N�̒��ړǂݏo���ɑΉ����܂����B
- todo: GPU��PostGIS��St_intersect()�ɑΉ����܂����B
- todo: heterodb-extra�p�b�P�[�W��Ubuntu 20.04�ɑΉ����܂����B
}
@en{}

@ja:##�����
@en:##Prerequisites

@ja{
- PostgreSQL v11, v12, v13, v14
- CUDA Toolkit 11.4 �ȍ~
- CUDA Toolkit�̃T�|�[�g����Linux�f�B�X�g���r���[�V����
- Intel x86 64bit �A�[�L�e�N�`��(x86_64)
- NVIDIA GPU CC 6.0 �ȍ~ (Pascal�ȍ~; Volta�ȍ~�𐄏�)
}
@en{
- PostgreSQL v11, v12, v13, v14
- CUDA Toolkit 11.4 or later
- Linux distributions supported by CUDA Toolkit
- Intel x86 64bit architecture (x86_64)
- NVIDIA GPU CC 6.0 or later (Pascal at least; Volta or newer is recommended)
}

@ja:##Arrow_Fdw�̓��v���T�|�[�g
@en:##Arrow_Fdw supports min/max statistics

@ja{
Pg2Arrow��min/max���v���t����Apache Arrow�t�@�C���𐶐����鎖���ł���悤�ɂȂ�܂����B

Apache Arrow�t�@�C���́A�����I��Record Batch�ƌĂ΂�镛�u���b�N�P�ʂŃf�[�^���Ǘ����Ă���A
�Ⴆ��Ȃ�A�S�̂�1�����̃f�[�^��L����Apache Arrow�t�@�C���̓����ɁA50�����̃f�[�^��ێ�����
Record Batch��200�ێ����Ă���A�Ƃ������t�@�C���`����L���Ă��܂��B

Pg2Arrow�̐V���ȃI�v�V����`--stat=COLUMN_NAME`�́ARecordBatch�P�ʂŎw�肵����̍ő�l/�ŏ��l��
�L�^���Ă����A�����Apache Arrow��Custom-Metadata���J�j�Y���𗘗p���ăt�b�^�ɖ��ߍ��݂܂��B

min/max���v���ɑΉ����Ă��Ȃ��A�v���P�[�V��������́A�P����Custom-Metadata�t�B�[���h��
���ߍ��܂ꂽ���m��Key-Value�����Ƃ��Ĉ����邽�߁A���݉^�p���ɖ�肪�����鎖�͂���܂���B
}

@ja{
Arrow_Fdw�����Apache Arrow�t�@�C����ǂݏo���ہA��L��min/max���v���𗘗p����
�͈̓C���f�b�N�X�X�L�����ɑΉ����܂����B

�Ⴆ�΁AArrow_Fdw�O���e�[�u���ɑ΂��錟���������ȉ��̂悤�Ȃ��̂ł������ꍇ�A

`WHERE ymd BETERRN '2020-01-01'::date AND '2021-12-31'::date`

ymd�t�B�[���h�̍ő�l��`'2020-01-01'::date`�����ł���Record Batch��A
ymd�t�B�[���h�̍ŏ��l��`'2021-12-31`::date`���傫��Record Batch�́A
���������Ƀ}�b�`���Ȃ��������炩�ł��邽�߁AArrow_Fdw�͂���Record Batch��ǂݔ�΂��܂��B

����ɂ��A�Ⴆ�΃��O�f�[�^�̃^�C���X�^���v�ȂǁA�߂����l�������R�[�h���ߖT�ɏW�܂��Ă���
�p�^�[���̃f�[�^�Z�b�g�ɂ����ẮA�͈̓C���f�b�N�X��p�����i���݂Ɠ����̐��\�������܂��B
}

@ja:##�W�񏈗��iGpuPreAgg�j�̉��ǂ�HyperLogLog�Ή�
@en:##Aggregation (GpuPreAgg) renewal and HyperLogLog support

@ja{
�W�񏈗��iGpuPreAgg�j��GPU���̎�������V���܂����B

`GROUP BY`�̂Ȃ��W�񉉎Z��A�O���[�v���̏��Ȃ��W�񏈗��̏ꍇ�́AL1�L���b�V���Ɠ�����
�A�N�Z�X���x�����uGPU���L�������v��ł̏W�񏈗����s���A���x�ቺ�̌����ƂȂ�₷���A
�O���[�o���������ւ̃A�g�~�b�N���Z�̉񐔂��팸���Ă��܂��B

�܂��AGPU��̃n�b�V���e�[�u���̃f�[�^�\�������ǂ��鎖�ŁA�n�b�V���X���b�g�̋�������������
�ۂɂ��p�t�H�[�}���X�̒ቺ���N����ɂ����Ȃ��Ă��܂��B
}

@ja{
HyperLogLog�ɂ��J�[�f�B�i���e�B�̐���ɑΉ����܂����B

`SELECT COUNT(distinct KEY)`�͔��ɂ悭�g���鏈���ł����A��K�͂ȃf�[�^�ɑ΂���
�d���̂Ȃ��L�[�l�̐��i�J�[�f�B�i���e�B�j���W�v����ꍇ�A���񕪎U�����Ƒ������������߁A
�����������Ԃ�v����Ƃ�����肪����܂����B

HyperLogLog�Ƃ́A�n�b�V���������L�[�l�̓��v�I�����𗘗p���āA���`���Ԃ��\���\��
����������ʂŃJ�[�f�B�i���e�B�𐄒肷��A���S���Y���ł��B

PG-Strom v4.0�ł́AHyperLogLog���g�p���ăJ�[�f�B�i���e�B�𐄒肷�邽�߂̏W��֐�
`hll_count(KEY)`���ǉ�����܂����B
}







@ja:##���̑��̕ύX
@en:##Other updates









@ja:##�p�~���ꂽ�@�\
@en:##Deprecated features
















