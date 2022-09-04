#include<stdio.h>
void eDFS(int v,int level);
int G[100][100];
int visited[100];
int vnum;
int flag=0;
int main()
{
	
	int en,emo,v1,v2;
	int i;
	scanf("%d%d",&vnum,&en);
	for(i=0;i<en;i++)
	{
		scanf("%d%d",&v1,&v2);
		G[v1][v2]=G[v2][v1]=1;
	}
	visited[1]=1;
	eDFS(1,1);
	
	printf("%d",flag);
	return 0;
	
}
void eDFS(int v,int level)  // a0 presents v ,a1 presents level;
{
	int j;
	if(level==vnum)
	{
		if(G[v][1]==1)
		flag=1;
		return;
	}
	for(j=1;j<=vnum;j++)
	{
		if(!visited[j]&&G[v][j]==1)
		{
			visited[j]=1;
			eDFS(j,level+1);//jal   eDFS
			
			visited[j]=0;
		}
	}
}
