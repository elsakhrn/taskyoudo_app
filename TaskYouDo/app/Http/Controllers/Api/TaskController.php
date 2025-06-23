<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Task;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    public function index()
    {
        $tasks = Task::all();
        return response()->json($tasks);
    }
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'judul_tugas' => 'required|string|max:255',
            'mata_kuliah' => 'required|string|max:255',
            'deskripsi_tugas' => 'required|string',
            'jenis_tugas' => 'required|string|max:50',
            'warna' => 'required|string|max:20',
            'tanggal_mulai' => 'required|date',
            'tanggal_selesai' => 'required|date|after_or_equal:tanggal_mulai',
            'pengingat' => 'required|integer|min:1',
        ]);

        $task = Task::create($validatedData);
        return response()->json($task, 201);
    }
    
    public function show(Task $task)
    {;
        return response()->json($task);
    }

    public function update(Request $request, Task $task)
    {
        // Logic to update a specific task by ID
        $validatedData = $request->validate([
            'judul_tugas' => 'required|string|max:255',
            'mata_kuliah' => 'required|string|max:255',
            'deskripsi_tugas' => 'required|string',
            'jenis_tugas' => 'required|string|max:50',
            'warna' => 'required|string|max:20',
            'tanggal_mulai' => 'required|date',
            'tanggal_selesai' => 'required|date|after_or_equal:tanggal_mulai',
            'pengingat' => 'required|integer|min:1',
        ]);

        $task->update($validatedData);
        return response()->json($task, 201);
    }
    public function destroy(Task $task)
    {
        // Logic to delete a specific task by ID
        $task->delete();
        return response()->json(["message" => "Data berhasil dihapus"], 204);
    }
}
