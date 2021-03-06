$inputor = null
app = null

describe "api", ->

  beforeEach ->
    loadFixtures("inputors.html")
    $inputor = $("#inputor").atwho at: "@", data: fixtures["names"]
    app = getAppOf $inputor

  describe "inner", ->

    controller = null
    callbacks = null

    beforeEach ->
      controller = app.controller()

    it "can get current data", ->
      simulateTypingIn $inputor
      expect(controller.model.fetch().length).toBe 24

    it "can save current data", ->
      simulateTypingIn $inputor
      data = [{id: 1, name: "one"}, {id: 2, name: "two"}]
      controller.model.save(data)
      expect(controller.model.fetch().length).toBe 2

    it "don't change data setting while using remote filter", ->
      jasmine.Ajax.install()
      $inputor.atwho
        at: "@"
        data: "/atwho.json"

      simulateTypingIn $inputor

      request = jasmine.Ajax.requests.mostRecent()
      response_data = [{"name":"Jacob"}, {"name":"Joshua"}, {"name":"Jayden"}]
      request.response
        status: 200
        responseText: JSON.stringify(response_data)

      expect(controller.get_opt("data")).toBe "/atwho.json"
      expect(controller.model.fetch().length).toBe 3


  describe "public", ->
    controller = null
    data = []

    beforeEach ->
      controller = app.controller()
      data = [
        {one: 1}
        {two: 2}
        {three: 3}
      ]

    it "can load data for special flag", ->
      $inputor.atwho "load", "@", data
      expect(controller.model.fetch().length).toBe data.length

    it "can load data with alias", ->
      $inputor.atwho at: "@", alias: "at"
      $inputor.atwho "load", "at", data
      expect(controller.model.fetch().length).toBe data.length

    it "can run it handly", ->
      app.set_context_for null
      $inputor.caret('pos', 31)
      $inputor.atwho "run"

      expect(app.controller().view.$el).not.toBeHidden()

    it 'destroy', ->
      $inputor.atwho at: "~"
      view_id = app.controller('~').view.$el.attr('id')
      $inputor.atwho 'destroy'
      expect($("##{view_id}").length).toBe 0
      expect($inputor.data('atwho')).toBe null
      expect($inputor.data('~')).toBe null
