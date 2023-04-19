extends Skeleton3D

@export var xr_origin: XROrigin3D
@export var source_skeleton: Skeleton3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if source_skeleton:
		var origin: Vector3 = source_skeleton.global_transform.origin - xr_origin.global_transform.origin
		
		set_global_transform(Transform3D(source_skeleton.get_global_transform().basis, xr_origin.global_transform.origin + origin))
		for bone_id in source_skeleton.get_bone_count():
				set_bone_pose_position(bone_id, source_skeleton.get_bone_pose_position(bone_id))
				set_bone_pose_rotation(bone_id, source_skeleton.get_bone_pose_rotation(bone_id))
