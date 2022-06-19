$global:result

# main form declaration 
Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Ferramenta de Espelhamento'
$main_form.Width = 340
$main_form.Height = 370
$main_form.BackColor = "white"
$main_form.FormBorderStyle = 'Fixed3D'
$main_form.MaximizeBox = $false

# user label
$objLabel = New-Object System.Windows.Forms.label
$objLabel.Location = New-Object System.Drawing.Size(7,10)
$objLabel.Size = New-Object System.Drawing.Size(130,15)
$objLabel.BackColor = "Transparent"
$objLabel.ForeColor = "black"
$objLabel.Text = "Digite o usuário de rede:"

# user input
$TextBoxUsername = New-Object System.Windows.Forms.TextBox
$TextBoxUsername.Location = '10,30'
$TextBoxUsername.Size = '100,50'

# group label
$objLabel2 = New-Object System.Windows.Forms.label
$objLabel2.Location = New-Object System.Drawing.Size(7,60)
$objLabel2.Size = New-Object System.Drawing.Size(130,15)
$objLabel2.BackColor = "Transparent"
$objLabel2.ForeColor = "black"
$objLabel2.Text = "Digite o tipo de Grupo:"

# user input
$TextBoxGroup = New-Object System.Windows.Forms.TextBox
$TextBoxGroup.Location = '10,80'
$TextBoxGroup.Size = '100,50'

# search button declaration
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(189,30)
$Button.Size = New-Object System.Drawing.Size(120,23)
$Button.Text = "Buscar"

# searchButton onclick event 
$Button.Add_Click($Button_Click)
$Button_Click = {searchFunction}

function searchFunction {

    $usernameValue = $TextBoxUsername.Text
    $usernameFilter = $TextBoxGroup.Text

    if($TextBoxUsername.TextLength -eq 0){
     [System.Windows.MessageBox]::Show('Preencha o campo usuário de rede!','Ferramenta de Espelhamento')
    }else{

   if ($TextBoxGroup.TextLength -eq 0){
   Write-Host "ENTREI AQUI"
    $global:result = (Get-ADPrincipalGroupMembership  $usernameValue | Select-Object -ExpandProperty name )-join ";`r`n"
    $TextBoxOutput.Text = $global:result
   }
    else{

    $global:result = (Get-ADPrincipalGroupMembership  $usernameValue | Select-Object -ExpandProperty name | select-string -pattern "$usernameFilter"  )-join ";`r`n"
    $TextBoxOutput.Text = $global:result
 }
 }
}

# copyButton declaration
$ButtonCopy = New-Object System.Windows.Forms.Button
$ButtonCopy.Location = New-Object System.Drawing.Size(10,300)
$ButtonCopy.Size = New-Object System.Drawing.Size(100,23)
$ButtonCopy.Text = "Copiar Clipboard"

# copyButton onclick event 
$ButtonCopy.Add_Click($ButtonCopy_Click)
$ButtonCopy_Click = {copyFunction}

function copyFunction {
    [System.Windows.MessageBox]::Show('Grupos copiados para Clipboard!','Ferramenta de Espelhamento')
 Set-Clipboard -Value $global:result
}

# result output
$TextBoxOutput = New-Object System.Windows.Forms.TextBox
$TextBoxOutput.multiline = $true
$TextBoxOutput.Location = '10,110'
$TextBoxOutput.Size = '300,150'
$TextBoxOutput.ReadOnly = "true"
$TextBoxOutput.ScrollBars = "Vertical" 

#import elements to form
$main_form.Controls.Add($objLabel)
$main_form.Controls.Add($TextBoxUsername)
$main_form.Controls.Add($objLabel2)
$main_form.Controls.Add($TextBoxGroup)
$main_form.Controls.Add($TextBoxOutput)
$main_form.Controls.Add($Button)
$main_form.Controls.Add($ButtonCopy)

#show program 
$main_form.ShowDialog()