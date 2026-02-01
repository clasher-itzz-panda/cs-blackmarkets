import { useState, useEffect } from 'react'
import { Home, MapPin, X, Navigation, Plus, Pencil, Trash2, Package } from 'lucide-react'

interface ZoneItem {
  name: string
  price: number
}

interface Zone {
  id: number
  name: string
  coords: { x: number; y: number; z: number }
  type: 'sell' | 'buy'
  items: ZoneItem[]
}

function App() {
  const [visible, setVisible] = useState(false)
  const [page, setPage] = useState<'home' | 'zones'>('home')
  const [zones, setZones] = useState<Zone[]>([])
  const [editModalOpen, setEditModalOpen] = useState(false)
  const [editingZone, setEditingZone] = useState<Zone | null>(null)

  const totalZones = zones.length
  const sellZones = zones.filter(z => z.type === 'sell').length
  const buyZones = zones.filter(z => z.type === 'buy').length
  const totalItems = zones.reduce((acc, z) => acc + z.items.length, 0)

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const data = event.data
      if (data.action === 'open') {
        setVisible(true)
      } else if (data.action === 'close') {
        setVisible(false)
      } else if (data.action === 'setZones') {
        setZones(data.zones || [])
      }
    }
    window.addEventListener('message', handleMessage)
    return () => window.removeEventListener('message', handleMessage)
  }, [])

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && visible) {
        handleClose()
      }
    }
    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [visible])

  const handleClose = () => {
    setVisible(false)
    setEditModalOpen(false)
    setEditingZone(null)
    fetch(`https://${GetParentResourceName()}/close`, { method: 'POST', body: JSON.stringify({}) })
  }

  const handleTeleport = (coords: { x: number; y: number; z: number }) => {
    fetch(`https://${GetParentResourceName()}/teleport`, {
      method: 'POST',
      body: JSON.stringify(coords)
    })
  }

  const handleEdit = (zone: Zone) => {
    setEditingZone({ ...zone, items: [...zone.items] })
    setEditModalOpen(true)
  }

  const handleDelete = (id: number) => {
    fetch(`https://${GetParentResourceName()}/deleteZone`, {
      method: 'POST',
      body: JSON.stringify({ id })
    }).then(() => {
      setZones(zones.filter(z => z.id !== id))
    })
  }

  const handleAddZone = () => {
    const newZone: Zone = {
      id: Date.now(),
      name: 'New Zone',
      coords: { x: 0, y: 0, z: 0 },
      type: 'sell',
      items: []
    }
    setEditingZone(newZone)
    setEditModalOpen(true)
  }

  const handleSaveZone = () => {
    if (!editingZone) return
    fetch(`https://${GetParentResourceName()}/saveZone`, {
      method: 'POST',
      body: JSON.stringify(editingZone)
    }).then(() => {
      const existingIndex = zones.findIndex(z => z.id === editingZone.id)
      if (existingIndex >= 0) {
        const newZones = [...zones]
        newZones[existingIndex] = editingZone
        setZones(newZones)
      } else {
        setZones([...zones, editingZone])
      }
      setEditModalOpen(false)
      setEditingZone(null)
    })
  }

  const handleGetCurrentCoords = () => {
    fetch(`https://${GetParentResourceName()}/getCoords`, {
      method: 'POST',
      body: JSON.stringify({})
    })
      .then(res => res.json())
      .then(coords => {
        if (editingZone && coords) {
          setEditingZone({ ...editingZone, coords })
        }
      })
  }

  const handleAddItem = () => {
    if (!editingZone) return
    setEditingZone({
      ...editingZone,
      items: [...editingZone.items, { name: '', price: 0 }]
    })
  }

  const handleUpdateItem = (index: number, field: 'name' | 'price', value: string | number) => {
    if (!editingZone) return
    const newItems = [...editingZone.items]
    newItems[index] = { ...newItems[index], [field]: value }
    setEditingZone({ ...editingZone, items: newItems })
  }

  const handleRemoveItem = (index: number) => {
    if (!editingZone) return
    const newItems = editingZone.items.filter((_, i) => i !== index)
    setEditingZone({ ...editingZone, items: newItems })
  }

  if (!visible) return null

  return (
    <div className="container">
      <div className="sidebar">
        <div className="sidebar-header">
          <Package size={28} />
          <span>Black Markets</span>
        </div>
        
        <nav className="sidebar-nav">
          <button 
            className={`nav-btn ${page === 'home' ? 'active' : ''}`}
            onClick={() => setPage('home')}
          >
            <Home size={20} />
            <span>Home</span>
          </button>
          <button 
            className={`nav-btn ${page === 'zones' ? 'active' : ''}`}
            onClick={() => setPage('zones')}
          >
            <MapPin size={20} />
            <span>Manage Zones</span>
          </button>
        </nav>
      </div>

      <div className="main-content">
        {page === 'home' && (
          <div className="home-page">
            <h1>Dashboard</h1>
            <p className="subtitle">Overview of your black market zones</p>
            
            <div className="stats-grid">
              <div className="stat-card">
                <div className="stat-icon blue">
                  <MapPin size={24} />
                </div>
                <div className="stat-info">
                  <span className="stat-value">{totalZones}</span>
                  <span className="stat-label">Total Zones</span>
                </div>
              </div>
              
              <div className="stat-card">
                <div className="stat-icon green">
                  <Package size={24} />
                </div>
                <div className="stat-info">
                  <span className="stat-value">{sellZones}</span>
                  <span className="stat-label">Sell Zones</span>
                </div>
              </div>
              
              <div className="stat-card">
                <div className="stat-icon orange">
                  <Package size={24} />
                </div>
                <div className="stat-info">
                  <span className="stat-value">{buyZones}</span>
                  <span className="stat-label">Buy Zones</span>
                </div>
              </div>
              
              <div className="stat-card">
                <div className="stat-icon purple">
                  <Package size={24} />
                </div>
                <div className="stat-info">
                  <span className="stat-value">{totalItems}</span>
                  <span className="stat-label">Total Items</span>
                </div>
              </div>
            </div>
          </div>
        )}

        {page === 'zones' && (
          <div className="zones-page">
            <div className="zones-header">
              <div>
                <h1>Manage Zones</h1>
                <p className="subtitle">Configure your black market locations</p>
              </div>
              <button className="btn-primary" onClick={handleAddZone}>
                <Plus size={18} />
                <span>Add Zone</span>
              </button>
            </div>
            
            <div className="table-container">
              <table className="zones-table">
                <thead>
                  <tr>
                    <th>Name</th>
                    <th>Coordinates</th>
                    <th>Type</th>
                    <th>Items</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {zones.map(zone => (
                    <tr key={zone.id}>
                      <td className="zone-name">{zone.name}</td>
                      <td className="zone-coords">
                        <span className="coords-text">
                          {zone.coords.x.toFixed(2)}, {zone.coords.y.toFixed(2)}, {zone.coords.z.toFixed(2)}
                        </span>
                        <button 
                          className="btn-icon" 
                          onClick={() => handleTeleport(zone.coords)}
                          title="Teleport"
                        >
                          <Navigation size={16} />
                        </button>
                      </td>
                      <td>
                        <span className={`type-badge ${zone.type}`}>
                          {zone.type}
                        </span>
                      </td>
                      <td className="items-count">{zone.items.length} items</td>
                      <td className="actions">
                        <button 
                          className="btn-icon edit" 
                          onClick={() => handleEdit(zone)}
                          title="Edit"
                        >
                          <Pencil size={16} />
                        </button>
                        <button 
                          className="btn-icon delete" 
                          onClick={() => handleDelete(zone.id)}
                          title="Delete"
                        >
                          <Trash2 size={16} />
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>

      {editModalOpen && editingZone && (
        <div className="modal-overlay" onClick={() => setEditModalOpen(false)}>
          <div className="modal" onClick={e => e.stopPropagation()}>
            <div className="modal-header">
              <h2>{zones.find(z => z.id === editingZone.id) ? 'Edit Zone' : 'Add Zone'}</h2>
              <button className="btn-close" onClick={() => setEditModalOpen(false)}>
                <X size={20} />
              </button>
            </div>
            
            <div className="modal-body">
              <div className="form-group">
                <label>Zone Name</label>
                <input 
                  type="text" 
                  value={editingZone.name}
                  onChange={e => setEditingZone({ ...editingZone, name: e.target.value })}
                  placeholder="Enter zone name"
                />
              </div>
              
              <div className="form-group">
                <label>Coordinates</label>
                <div className="coords-input-group">
                  <input 
                    type="number" 
                    value={editingZone.coords.x}
                    onChange={e => setEditingZone({ 
                      ...editingZone, 
                      coords: { ...editingZone.coords, x: parseFloat(e.target.value) || 0 }
                    })}
                    placeholder="X"
                  />
                  <input 
                    type="number" 
                    value={editingZone.coords.y}
                    onChange={e => setEditingZone({ 
                      ...editingZone, 
                      coords: { ...editingZone.coords, y: parseFloat(e.target.value) || 0 }
                    })}
                    placeholder="Y"
                  />
                  <input 
                    type="number" 
                    value={editingZone.coords.z}
                    onChange={e => setEditingZone({ 
                      ...editingZone, 
                      coords: { ...editingZone.coords, z: parseFloat(e.target.value) || 0 }
                    })}
                    placeholder="Z"
                  />
                  <button className="btn-secondary" onClick={handleGetCurrentCoords}>
                    <Navigation size={16} />
                    <span>Get Position</span>
                  </button>
                </div>
              </div>
              
              <div className="form-group">
                <label>Type</label>
                <select 
                  value={editingZone.type}
                  onChange={e => setEditingZone({ ...editingZone, type: e.target.value as 'sell' | 'buy' })}
                >
                  <option value="sell">Sell</option>
                  <option value="buy">Buy</option>
                </select>
              </div>
              
              <div className="form-group">
                <div className="items-header">
                  <label>Items & Prices</label>
                  <button className="btn-add-item" onClick={handleAddItem}>
                    <Plus size={14} />
                    <span>Add Item</span>
                  </button>
                </div>
                <div className="items-list">
                  {editingZone.items.map((item, index) => (
                    <div key={index} className="item-row">
                      <input 
                        type="text" 
                        value={item.name}
                        onChange={e => handleUpdateItem(index, 'name', e.target.value)}
                        placeholder="Item name"
                      />
                      <input 
                        type="number" 
                        value={item.price}
                        onChange={e => handleUpdateItem(index, 'price', parseFloat(e.target.value) || 0)}
                        placeholder="Price"
                      />
                      <button className="btn-icon delete" onClick={() => handleRemoveItem(index)}>
                        <Trash2 size={14} />
                      </button>
                    </div>
                  ))}
                  {editingZone.items.length === 0 && (
                    <p className="no-items">No items added yet</p>
                  )}
                </div>
              </div>
            </div>
            
            <div className="modal-footer">
              <button className="btn-cancel" onClick={() => setEditModalOpen(false)}>Cancel</button>
              <button className="btn-save" onClick={handleSaveZone}>Save Zone</button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default App

declare global {
  interface Window {
    GetParentResourceName?: () => string
  }
}

function GetParentResourceName(): string {
  if (typeof window !== 'undefined' && window.GetParentResourceName) {
    return window.GetParentResourceName()
  }
  return 'cs-blackmarkets'
}

