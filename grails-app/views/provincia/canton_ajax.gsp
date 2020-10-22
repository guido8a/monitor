<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 22/10/20
  Time: 12:16
--%>

    <div class="col-md-2">
        <label>
            Cantón
        </label>
    </div>
    <div class="col-md-6">
        <g:select name="canton" from="${cantones}" optionKey="id" optionValue="nombre" class="form-control"/>
    </div>


