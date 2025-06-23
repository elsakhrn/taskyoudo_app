<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('tb_tugas', function (Blueprint $table) {
            $table->id();
            $table->string('judul_tugas');
            $table->string('mata_kuliah');
            $table->text('deskripsi_tugas')->nullable();
            $table->string('jenis_tugas');
            $table->string('warna');
            $table->date('tanggal_mulai');
            $table->date('tanggal_selesai');
            $table->integer('pengingat');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tb_tugas');
    }
};
