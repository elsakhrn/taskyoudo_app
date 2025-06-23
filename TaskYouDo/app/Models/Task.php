<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
    protected $table = 'tb_tugas';
    protected $fillable = [
        'judul_tugas',
        'mata_kuliah',
        'deskripsi_tugas',
        'jenis_tugas',
        'warna',
        'tanggal_mulai',
        'tanggal_selesai',
        'pengingat',
    ];

    public $timestamps = false; // Disable timestamps if not needed
}
