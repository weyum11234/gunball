extends Node3D

@onready var mainMenu = $CanvasLayer/MainMenu
@onready var addressEntry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var hud = $CanvasLayer/HUD
@onready var damageGauge = $CanvasLayer/HUD/DamageGauge

const PLAYER = preload("res://assets/player.tscn")
const PORT = 9999
var enetPeer = ENetMultiplayerPeer.new()

func _unhandled_input(event):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit();

func _on_host_button_pressed():
	mainMenu.hide()
	hud.show()
	
	enetPeer.create_server(PORT)
	multiplayer.multiplayer_peer = enetPeer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())

func _on_join_button_pressed():
	mainMenu.hide()
	hud.show()
	
	enetPeer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enetPeer

func _on_multiplayer_spawner_spawned(node):
	if node.is_multiplayer_authority():
		node.damageChanged.connect(update_damage_gauge)

func add_player(peerID):
	var player = PLAYER.instantiate()
	player.name = str(peerID)
	add_child(player)
	
	if player.is_multiplayer_authority():
		player.damageChanged.connect(update_damage_gauge)

func remove_player(peerID):
	var player = get_node_or_null(str(peerID))
	if player:
		player.queue_free()

func update_damage_gauge(damageValue):
	damageGauge.text = str(damageValue)

func upnp_setup():
	var upnp = UPNP.new()
	
	var discoverResult = upnp.discover()
	assert(discoverResult == UPNP.UPNP_RESULT_SUCCESS, "UPNP Discover Failed! Error %s" % discoverResult)
	
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), "UPNP Invalid Gateway!")
	
	var mapResult = upnp.add_port_mapping(PORT)
	assert(mapResult == UPNP.UPNP_RESULT_SUCCESS, "UPNP Port Mapping Failed! Error %s" % mapResult)
	
	print("Success! Join Address: %s" % upnp.query_external_address())

